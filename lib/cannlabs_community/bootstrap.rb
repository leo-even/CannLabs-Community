# frozen_string_literal: true

# Audits, and on request applies, the native product state declared in
# config/cannlabs_community/bootstrap.yml. Everything is resolved by semantic
# identity and written through the same models, services and loggers the admin
# UI uses. Group memberships are never read as desired state and never changed.
module CannlabsCommunity
  class Bootstrap
    MANIFEST_PATH = "config/cannlabs_community/bootstrap.yml"
    EXIT_CODES = { pass: 0, drift: 1, blocked: 2 }.freeze
    USAGE_EXIT_CODE = 3
    PREREQUISITE = "deployment prerequisite missing"
    UNCATEGORIZED_CHANGE = "remove_and_replace_uncategorized"
    CONTENT_ROOT = "config/cannlabs_community"
    CONTENT_FIELD = "cannlabs_community_content"

    Result = Struct.new(:key, :status, :detail, :changed, keyword_init: true)

    class Blocked < StandardError
    end

    class InvalidProfile < StandardError
    end

    attr_reader :results, :profile

    def self.manifest
      YAML.safe_load_file(Rails.root.join(MANIFEST_PATH))
    end

    def self.run(profile:, apply: false, format: nil, out: $stdout)
      bootstrap = new(profile:)
      apply ? bootstrap.apply : bootstrap.audit
      out.puts(format == "json" ? JSON.pretty_generate(bootstrap.as_json) : bootstrap.report)
      EXIT_CODES.fetch(bootstrap.status)
    rescue InvalidProfile => e
      out.puts "ERROR: #{e.message}"
      USAGE_EXIT_CODE
    end

    def initialize(profile:, manifest: self.class.manifest)
      @manifest = manifest
      @profile = profile.to_s
      @results = []

      if !@manifest["profiles"].include?(@profile)
        raise InvalidProfile, "PROFILE must be one of: #{@manifest["profiles"].join(", ")}"
      end
    end

    def audit
      evaluate(apply: false)
    end

    def apply
      evaluate(apply: true)
    end

    def status
      statuses = results.map(&:status)
      return :blocked if statuses.include?(:blocked)
      statuses.include?(:drift) ? :drift : :pass
    end

    def report
      lines =
        results.map do |result|
          line = format("%-8s %-44s %s", result.status.to_s.upcase, result.key, result.detail)
          result.changed ? "#{line} [CHANGED]" : line
        end

      counts = results.map(&:status).tally
      summary =
        %i[pass drift blocked gated].map { |name| "#{name} #{counts.fetch(name, 0)}" }.join(", ")
      changes = results.count(&:changed)

      lines << ""
      lines << "#{@apply ? "APPLY" : "AUDIT"} profile=#{profile}: #{status.to_s.upcase} (#{summary})"
      lines << (changes.zero? ? "NO CHANGE" : "CHANGED #{changes}") if @apply
      lines.join("\n")
    end

    def as_json(*)
      {
        mode: @apply ? "apply" : "audit",
        profile:,
        status:,
        changed: results.count(&:changed),
        results: results.map(&:to_h),
      }
    end

    private

    def evaluate(apply:)
      @apply = apply
      @results = []
      @managed_category_ids = Set.new

      check_builtin_groups
      check_groups
      check_settings
      check_categories
      check_uncategorized
      check_retired_categories
      check_unmanaged_categories
      check_category_descriptions
      check_content_topics
      check_navigation
      check_sidebar
      check_text_overrides
      check_theme
      check_plugin

      results
    end

    # The block returns [status, detail], plus a repair for a drift that apply may
    # fix. After a repair the block runs again, so the reported state is observed.
    def invariant(key)
      status, detail, repair = yield
      changed = false

      if @apply && status == :drift && repair
        begin
          repair.call
          changed = true
          status, detail = yield
        rescue ActiveRecord::ActiveRecordError,
               Discourse::InvalidAccess,
               Discourse::InvalidParameters,
               Blocked => e
          status = :blocked
          detail = "apply failed: #{e.message}"
        end
      end

      results << Result.new(key:, status:, detail:, changed:)
    end

    def system_guardian
      Discourse.system_user.guardian
    end

    def staff_action_logger
      StaffActionLogger.new(Discourse.system_user)
    end

    def builtin_group(name)
      id = Group::AUTO_GROUPS[name.to_sym]
      Group.find_by(id:, automatic: true) if id
    end

    def find_group(name)
      return builtin_group(name) if Group::AUTO_GROUPS.key?(name.to_sym)
      Group.find_by(name:, automatic: false)
    end

    # A missing group that the manifest itself defines is created earlier in the
    # same apply run, so it is a drift. Any other missing group needs an operator.
    def missing_groups(names)
      if (names - @manifest["groups"].keys).empty?
        [:drift, "waits for group: #{names.join(", ")}"]
      else
        [:blocked, "group not found: #{names.join(", ")}"]
      end
    end

    def check_builtin_groups
      @manifest["builtin_groups"].each do |name|
        invariant("builtin_groups.#{name}") do
          if builtin_group(name)
            [:pass, "native automatic group present"]
          else
            [:blocked, "native automatic group missing"]
          end
        end
      end
    end

    def check_groups
      @manifest["groups"].each do |name, definition|
        desired = group_attributes(definition)

        invariant("groups.#{name}") do
          group = Group.find_by(name:)

          if group.nil?
            [
              :drift,
              "missing; apply creates it with no members",
              -> { create_group(name, desired) },
            ]
          elsif group.automatic
            [:blocked, "an automatic group already uses this name"]
          elsif (diff = desired.reject { |key, value| same_value?(group[key], value) }).any?
            [:drift, "differs: #{diff.keys.join(", ")}", -> { update_group(group, diff) }]
          elsif non_staff_owner?(group)
            [:blocked, "has an owner who is not staff; operator review required"]
          else
            [:pass, "defined and staff-controlled; membership not managed"]
          end
        end
      end
    end

    def group_attributes(definition)
      levels = Group.visibility_levels

      {
        "full_name" => definition["full_name"],
        "visibility_level" => levels.fetch(definition["visibility_level"].to_sym),
        "members_visibility_level" => levels.fetch(definition["members_visibility_level"].to_sym),
      }.merge(@manifest["group_controls"])
    end

    # Core treats an unset trust-level grant and 0 as the same "none", and only 0
    # passes validation once a grant has been set.
    def same_value?(current, desired)
      desired.is_a?(Integer) ? current.to_i == desired : current.presence == desired.presence
    end

    def create_group(name, attributes)
      result =
        Groups::Create.call(
          guardian: system_guardian,
          params: attributes.except("grant_trust_level").merge("name" => name).symbolize_keys,
        )
      raise Blocked, "group #{name} could not be created" if result.failure?
    end

    def update_group(group, attributes)
      group.update!(attributes)
      GroupActionLogger.new(Discourse.system_user, group).log_change_group_settings
    end

    def non_staff_owner?(group)
      group
        .group_users
        .where(owner: true)
        .joins(:user)
        .where(users: { admin: false, moderator: false })
        .exists?
    end

    def check_settings
      @manifest["settings"].each { |name, expected| check_setting(name, expected) }

      @manifest["profile_settings"].each do |name, by_profile|
        if by_profile.key?(profile)
          check_setting(name, by_profile[profile])
        else
          current = SiteSetting.has_setting?(name) ? SiteSetting.get(name).inspect : "not present"
          results << Result.new(
            key: "settings.#{name}",
            status: :gated,
            detail: "not managed in the #{profile} profile (current value: #{current})",
            changed: false,
          )
        end
      end
    end

    def check_setting(name, expected)
      invariant("settings.#{name}") do
        if !SiteSetting.has_setting?(name)
          if expected == false
            [:pass, "setting not present; the feature is not installed"]
          else
            [:blocked, "setting not present; #{PREREQUISITE}"]
          end
        elsif expected.is_a?(Array)
          group_list_setting(name, expected)
        elsif SiteSetting.get(name) == expected
          [:pass, expected.inspect]
        else
          [
            :drift,
            "is #{SiteSetting.get(name).inspect}, expected #{expected.inspect}",
            -> { SiteSetting.set_and_log(name, expected) },
          ]
        end
      end
    end

    def group_list_setting(name, group_names)
      missing = group_names.reject { |group_name| find_group(group_name) }
      return missing_groups(missing) if missing.any?

      expected_ids = group_names.map { |group_name| find_group(group_name).id }.sort
      current_ids = SiteSetting.get(name).to_s.split("|").map(&:to_i).sort

      if current_ids == expected_ids
        [:pass, group_names.join(", ")]
      else
        current = current_ids.map { |id| Group.find_by(id:)&.name || "##{id}" }.join(", ")
        [
          :drift,
          "is [#{current}], expected [#{group_names.join(", ")}]",
          -> { SiteSetting.set_and_log(name, expected_ids.join("|")) },
        ]
      end
    end

    def find_category(definition)
      if definition["site_setting"]
        id = SiteSetting.get(definition["site_setting"]).to_i
        Category.find_by(id:) if id > 0
      else
        Category.find_by(slug: definition["slug"], parent_category_id: nil)
      end
    end

    def resolve_permissions(permissions)
      missing = permissions.keys.reject { |group_name| find_group(group_name) }

      expected =
        (permissions.keys - missing).map do |group_name|
          type = CategoryGroup.permission_types.fetch(permissions[group_name].to_sym)
          [find_group(group_name).id, type]
        end

      [expected.sort, missing]
    end

    def acl_label(category)
      permissions = category.permissions_params
      return "public" if !category.read_restricted && permissions.empty?

      permissions
        .map { |group_name, type| "#{group_name}:#{CategoryGroup.permission_types.key(type)}" }
        .join(", ")
        .presence || "nobody"
    end

    # The manifest ACL is complete: the category must be restricted to exactly
    # these rows, so a qualified category can never also admit ordinary members.
    def acl_invariant(category, permissions, verify_only: false)
      expected, missing = resolve_permissions(permissions)
      return missing_groups(missing) if missing.any?

      wanted = permissions.map { |group_name, type| "#{group_name}:#{type}" }.join(", ")
      current = category.category_groups.pluck(:group_id, :permission_type).sort

      if category.read_restricted && current == expected
        [:pass, "#{category.slug} → #{wanted} only"]
      elsif verify_only
        [
          :blocked,
          "ACL is [#{acl_label(category)}], expected [#{wanted}]; operator review required",
        ]
      else
        [
          :drift,
          "ACL is [#{acl_label(category)}], expected [#{wanted}] only",
          -> { set_category_acl(category, expected) },
        ]
      end
    end

    def set_category_acl(category, expected)
      previous = category.permissions_params
      category.set_permissions(expected.to_h)
      category.save!

      staff_action_logger.log_category_settings_change(
        category,
        { permissions: category.permissions_params, read_restricted: true }.with_indifferent_access,
        old_permissions: previous,
      )
    end

    def create_category(definition, expected)
      category =
        Category.new(
          name: definition.dig("create", "name"),
          slug: definition["slug"],
          description: definition["description"],
          user: Discourse.system_user,
        )
      category.set_permissions(expected.to_h)
      category.save!

      staff_action_logger.log_category_creation(category)
    end

    def check_categories
      @manifest["categories"].each do |key, definition|
        invariant("categories.#{key}") do
          category = find_category(definition)

          if category
            @managed_category_ids << category.id
            acl_invariant(
              category,
              definition["permissions"],
              verify_only: definition["verify_only"],
            )
          elsif definition["create"]
            expected, missing = resolve_permissions(definition["permissions"])

            if missing.any?
              missing_groups(missing)
            else
              [:drift, "missing; apply creates it", -> { create_category(definition, expected) }]
            end
          else
            [:blocked, "native seeded category not found; #{PREREQUISITE}"]
          end
        end
      end
    end

    # The native upcoming change demotes the special category to a normal one and
    # records its id in the change's event log, which is how it is found here.
    def residual_uncategorized_category
      id =
        UpcomingChangeEvent
          .where(upcoming_change_name: UNCATEGORIZED_CHANGE)
          .where.not(event_data: nil)
          .order(:created_at)
          .filter_map { |event| event.event_data["uncategorized_category_id"] }
          .last

      Category.find_by(id:) if id
    end

    def check_uncategorized
      special_id = SiteSetting.uncategorized_category_id

      invariant("uncategorized.special_category") do
        if special_id == -1
          [:pass, "retired by the native upcoming change"]
        else
          [
            :blocked,
            "the special Uncategorized category is still active; enable the native " \
              "upcoming change #{UNCATEGORIZED_CHANGE}, then run again",
          ]
        end
      end

      if special_id != -1
        @managed_category_ids << special_id
        return
      end

      invariant("uncategorized.residual_category") do
        category = residual_uncategorized_category

        if category
          @managed_category_ids << category.id
          acl_invariant(category, @manifest.dig("uncategorized", "residual_permissions"))
        else
          [:pass, "no residual category"]
        end
      end
    end

    def check_retired_categories
      @manifest["retired_categories"].each do |key, definition|
        invariant("retired_categories.#{key}") do
          category = find_category(definition)

          if category.nil?
            [:pass, "absent (a stale #{definition["site_setting"]} value is tolerated)"]
          else
            @managed_category_ids << category.id
            blockers = retirement_blockers(category)

            if blockers.empty?
              [
                :drift,
                "the untouched seeded scaffold is present; apply retires it through native deletion",
                -> { retire_category(category) },
              ]
            else
              [
                :blocked,
                "present, but not provably the untouched seeded scaffold " \
                  "(#{blockers.join("; ")}); operator review required",
              ]
            end
          end
        end
      end
    end

    def retirement_blockers(category)
      system_id = Discourse::SYSTEM_USER_ID
      blockers = []

      blockers << "not created by the system user" if category.user_id != system_id
      blockers << "has subcategories" if category.has_children?

      other_topics =
        Topic.with_deleted.where(category_id: category.id).where.not(id: category.topic_id)
      blockers << "contains topics" if other_topics.exists?

      human_posts =
        Post
          .with_deleted
          .where(topic_id: category.topic_id)
          .where("user_id <> :id OR last_editor_id <> :id", id: system_id)
      blockers << "its definition topic has human posts or edits" if human_posts.exists?

      blockers << "a chat channel is attached to it" if chat_channel?(category)
      blockers << "native Guardian refuses deletion" if !system_guardian.can_delete?(category)

      blockers
    end

    def chat_channel?(category)
      defined?(::Chat::Channel) &&
        ::Chat::Channel.where(chatable_type: "Category", chatable_id: category.id).exists?
    end

    def retire_category(category)
      system_guardian.ensure_can_delete!(category)
      category.destroy!
      Discourse.cache.delete(Categories::TypeRegistry::COUNTS_CACHE_KEY)

      staff_action_logger.log_category_deletion(category)
    end

    def check_unmanaged_categories
      allowed_group_ids =
        [
          *@manifest["categories"].values.flat_map { |definition| definition["permissions"].keys },
          *@manifest.dig("uncategorized", "residual_permissions").keys,
        ].uniq.filter_map { |group_name| find_group(group_name)&.id }

      invariant("categories.unmanaged") do
        open =
          Category
            .where.not(id: @managed_category_ids.to_a)
            .includes(:category_groups)
            .reject do |category|
              category.read_restricted &&
                (category.category_groups.map(&:group_id) - allowed_group_ids).empty?
            end

        if open.empty?
          [:pass, "no category outside the manifest opens the paid boundary"]
        else
          [
            :blocked,
            "readable outside the paid boundary: #{open.map(&:slug).join(", ")}; " \
              "operator review required",
          ]
        end
      end
    end

    def waiting_for_category(key)
      if @manifest["categories"].fetch(key)["create"]
        [:drift, "waits for category: #{key}"]
      else
        [:blocked, "native seeded category not found: #{key}; #{PREREQUISITE}"]
      end
    end

    # The description is the first paragraph of the category's native definition
    # ("About") topic: revising that post is how the admin UI changes it.
    def check_category_descriptions
      @manifest["categories"].each do |key, definition|
        desired = definition["description"]
        next if desired.nil?

        invariant("category_descriptions.#{key}") do
          category = find_category(definition)
          post = category&.topic&.first_post

          if category.nil?
            waiting_for_category(key)
          elsif post.nil?
            [:blocked, "#{category.slug} has no definition topic; operator review required"]
          else
            title = about_title(category)
            differences = []
            differences << "description" if normalized(post.raw) != desired
            differences << "title" if post.topic.title != title

            if differences.empty?
              [:pass, desired]
            else
              [
                :drift,
                "differs: #{differences.join(", ")}",
                -> { revise_post(post, title:, raw: desired) },
              ]
            end
          end
        end
      end
    end

    def normalized(text)
      text.to_s.gsub("\r\n", "\n").strip
    end

    # The title core itself gives a category's definition topic, in the site language.
    def about_title(category)
      I18n
        .with_locale(SiteSetting.default_locale) do
          I18n.t("category.topic_prefix", category: category.name)
        end
        .strip
    end

    def content_body(definition)
      path = Rails.root.join(CONTENT_ROOT, definition["body"])
      raise Blocked, "content file not found: #{definition["body"]}" if !path.file?

      normalized(path.read)
    end

    def revise_post(post, attributes)
      if !post.revise(Discourse.system_user, attributes, skip_validations: true)
        raise Blocked,
              "post #{post.id} could not be revised: #{post.errors.full_messages.join("; ")}"
      end
    end

    def owned_topic(key)
      id = TopicCustomField.where(name: CONTENT_FIELD, value: key).pick(:topic_id)
      Topic.with_deleted.find_by(id:) if id
    end

    # An unedited topic seeded by core and still named by the site setting may be
    # taken over once. Anything a person touched, or already owned, is never adopted.
    def adoptable_topic(definition)
      return if !definition["adopt_seeded"]

      id = SiteSetting.get(definition["site_setting"]).to_i
      topic = Topic.find_by(id:) if id > 0
      post = topic&.first_post
      return if post.nil?
      return if topic.user_id != Discourse::SYSTEM_USER_ID
      return if post.last_editor_id != Discourse::SYSTEM_USER_ID
      return if TopicCustomField.where(topic_id: topic.id, name: CONTENT_FIELD).exists?

      topic
    end

    def content_differences(key, definition, category, topic, body)
      pointed = SiteSetting.get(definition["site_setting"]).to_i
      post = topic.first_post
      differences = []

      differences << "marker" if topic.custom_fields[CONTENT_FIELD] != key
      differences << "title" if topic.title != definition["title"]
      differences << "body" if post.nil? || normalized(post.raw) != body
      differences << "category" if topic.category_id != category.id
      differences << "pin" if definition["pinned_globally"] && !topic.pinned_globally?
      differences << "closed" if definition["closed"] && !topic.closed?
      differences << definition["site_setting"] if pointed != topic.id

      differences
    end

    def check_content_topics
      (@manifest["content_topics"] || {}).each do |key, definition|
        invariant("content_topics.#{key}") do
          category = find_category(@manifest["categories"].fetch(definition["category"]))
          next waiting_for_category(definition["category"]) if category.nil?

          body =
            begin
              content_body(definition)
            rescue Blocked => e
              next :blocked, e.message
            end

          owned = owned_topic(key)
          next :blocked, "the owned topic was deleted; operator review required" if owned&.trashed?

          topic = owned || adoptable_topic(definition)
          pointed = SiteSetting.get(definition["site_setting"]).to_i

          if topic.nil? && definition["adopt_seeded"] && Topic.exists?(id: pointed)
            next [
              :blocked,
              "#{definition["site_setting"]} names a topic that is not an unedited seeded " \
                "topic; operator review required"
            ]
          end

          converge = -> { converge_content_topic(key, definition, category) }

          if topic.nil?
            [:drift, "missing; apply creates it in #{category.slug}", converge]
          else
            differences = content_differences(key, definition, category, topic, body)

            if differences.empty?
              [:pass, "#{definition["title"]} in #{category.slug}"]
            else
              [:drift, "differs: #{differences.join(", ")}", converge]
            end
          end
        end
      end
    end

    def converge_content_topic(key, definition, category)
      body = content_body(definition)
      topic = owned_topic(key) || adoptable_topic(definition)

      if topic
        post = topic.first_post
        changes = {}
        changes[:title] = definition["title"] if topic.title != definition["title"]
        changes[:raw] = body if normalized(post.raw) != body
        changes[:category_id] = category.id if topic.category_id != category.id
        revise_post(post, changes) if changes.any?
      else
        post =
          PostCreator.create!(
            Discourse.system_user,
            title: definition["title"],
            raw: body,
            category: category.id,
            skip_jobs: true,
            skip_validations: true,
          )
        topic = post.topic
      end

      topic = Topic.find(topic.id)
      if topic.custom_fields[CONTENT_FIELD] != key
        topic.custom_fields[CONTENT_FIELD] = key
        topic.save_custom_fields
      end
      topic.update_pinned(true, true) if definition["pinned_globally"] && !topic.pinned_globally?
      if definition["closed"] && !topic.closed?
        topic.update_status("closed", true, Discourse.system_user, silent: true)
      end

      if SiteSetting.get(definition["site_setting"]).to_i != topic.id
        SiteSetting.set_and_log(definition["site_setting"], topic.id)
      end
    end

    def check_navigation
      keys = @manifest.dig("navigation", "default_categories")
      return if keys.nil?

      invariant("navigation.default_categories") do
        categories = keys.map { |key| find_category(@manifest["categories"].fetch(key)) }
        missing = keys.zip(categories).filter_map { |key, category| key if category.nil? }
        next waiting_for_category(missing.first) if missing.any?

        expected = categories.map(&:id)
        current = SiteSetting.default_navigation_menu_categories.to_s.split("|").map(&:to_i)

        if current == expected
          [:pass, keys.join(", ")]
        else
          known = Category.where(id: current).pluck(:id, :slug).to_h
          shown = current.map { |id| known[id] || "##{id} (missing)" }.join(", ")
          [
            :drift,
            "is [#{shown}], expected [#{keys.join(", ")}]",
            -> { set_default_navigation_categories(expected) },
          ]
        end
      end
    end

    # Like the admin UI's "update existing users": people who already have an account
    # receive the new default categories and lose the removed ones.
    def set_default_navigation_categories(category_ids)
      name = "default_navigation_menu_categories"
      previous = SiteSetting.get(name).to_s
      value = category_ids.join("|")

      SiteSetting.set_and_log(name, value)
      SiteSettingUpdateExistingUsers.call(name, value, previous)
    end

    def community_section
      SidebarSection.find_by(section_type: :community)
    end

    # The community section is edited through the same updater as the admin UI. A
    # built-in link that is missing is restored first by the native reset.
    def check_sidebar
      expected = @manifest.dig("sidebar", "community_links")
      return if expected.nil?

      invariant("sidebar.community_links") do
        section = community_section
        next :blocked, "the community sidebar section is missing; #{PREREQUISITE}" if !section

        current = section.sidebar_urls.map(&:value)
        extra = current - expected
        missing = expected - current

        if extra.empty? && missing.empty?
          [:pass, expected.join(", ")]
        else
          detail = []
          detail << "extra: #{extra.join(", ")}" if extra.any?
          detail << "missing: #{missing.join(", ")}" if missing.any?
          [:drift, detail.join("; "), -> { trim_community_section(section, expected) }]
        end
      end
    end

    def trim_community_section(section, expected)
      section.reset_community! if (expected - section.sidebar_urls.map(&:value)).any?
      section = community_section
      extra = section.sidebar_urls.reject { |url| expected.include?(url.value) }
      return if extra.empty?

      SidebarSectionUpdater.update!(
        sidebar_section: section,
        user: Discourse.system_user,
        section_params: {
        },
        links_params: extra.map { |url| { id: url.id, _destroy: true } },
      )
    end

    def check_text_overrides
      (@manifest["text_overrides"] || {}).each do |locale, overrides|
        overrides.each do |key, desired|
          invariant("text_overrides.#{locale}.#{key}") do
            current = TranslationOverride.find_by(locale:, translation_key: key)

            if !I18n.overrides_disabled { I18n.exists?(key, :en) }
              [:blocked, "translation key not found upstream; operator review required"]
            elsif current&.value == desired
              [:pass, "customized"]
            else
              [
                :drift,
                current ? "customized differently" : "not customized",
                -> { set_text_override(locale, key, desired, current&.value) },
              ]
            end
          end
        end
      end
    end

    def set_text_override(locale, key, desired, previous)
      override = TranslationOverride.upsert!(locale, key, desired)

      if override.errors.any?
        raise Blocked, "#{key} was rejected: #{override.errors.full_messages.join("; ")}"
      end

      staff_action_logger.log_site_text_change(key, desired, previous)
    end

    def same_repository?(url, expected)
      normalize = ->(value) { value.to_s.strip.delete_suffix("/").delete_suffix(".git").downcase }
      normalize.call(url) == normalize.call(expected)
    end

    def check_theme
      expected = @manifest["theme"]
      remote =
        RemoteTheme.all.find do |candidate|
          same_repository?(candidate.remote_url, expected["repository"])
        end
      theme = remote && Theme.find_by(remote_theme_id: remote.id)

      invariant("theme.installed") do
        if theme
          [:pass, "#{theme.name} from #{expected["repository"]}"]
        else
          [:blocked, "the theme from #{expected["repository"]} is not installed; #{PREREQUISITE}"]
        end
      end
      return if theme.nil?

      pinned = remote.local_version == expected["revision"]

      invariant("theme.revision") do
        if pinned
          [:pass, expected["revision"]]
        else
          [
            :blocked,
            "installed revision is #{remote.local_version.inspect}, expected " \
              "#{expected["revision"]}; themes are updated by the deployment layer",
          ]
        end
      end

      invariant("theme.auto_update") do
        if theme.reload.auto_update
          [
            :drift,
            "automatic updates are on; the theme must stay pinned",
            -> { theme.update!(auto_update: false) },
          ]
        else
          [:pass, "pinned (automatic updates off)"]
        end
      end

      invariant("theme.default") do
        if SiteSetting.default_theme_id == theme.id
          [:pass, "default theme"]
        elsif pinned && theme.enabled && !theme.component
          [:drift, "installed but not the default theme", -> { theme.set_default! }]
        else
          [:blocked, "not the default theme and not safe to activate; operator review required"]
        end
      end
    end

    def check_plugin
      expected = @manifest["plugin"]
      plugin = Discourse.plugins.find { |candidate| candidate.name == expected["name"] }

      invariant("plugin.loaded") do
        if plugin.nil?
          [:blocked, "#{expected["name"]} is not loaded; #{PREREQUISITE}"]
        elsif !same_repository?(plugin.metadata.url, expected["repository"])
          [:blocked, "loaded from an unexpected repository: #{plugin.metadata.url.inspect}"]
        else
          [:pass, "#{expected["name"]} from #{expected["repository"]}"]
        end
      end
      return if plugin.nil?

      invariant("plugin.revision") do
        if plugin.commit_hash == expected["revision"]
          [:pass, expected["revision"]]
        else
          [
            :blocked,
            "loaded revision is #{plugin.commit_hash.inspect}, expected #{expected["revision"]}",
          ]
        end
      end

      invariant("plugin.scheduled_job") do
        job = expected["scheduled_job"].safe_constantize
        interval = expected["every_minutes"].minutes

        if job && MiniScheduler::Manager.discover_schedules.include?(job) && job.every == interval
          [:pass, "#{expected["scheduled_job"]} every #{expected["every_minutes"]} minutes"]
        else
          [
            :blocked,
            "#{expected["scheduled_job"]} is not registered every " \
              "#{expected["every_minutes"]} minutes",
          ]
        end
      end

      invariant("plugin.groups") do
        if expected["groups_constant"].safe_constantize&.sort == @manifest["groups"].keys.sort
          [:pass, "the plugin and the manifest name the same groups"]
        else
          [:blocked, "the plugin's group names differ from the manifest"]
        end
      end
    end
  end
end
