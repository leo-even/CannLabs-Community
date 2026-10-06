# frozen_string_literal: true

RSpec.describe CannlabsCommunity::Bootstrap do
  subject(:bootstrap) { described_class.new(profile: "production", manifest:) }

  fab!(:general) { Fabricate(:category, name: "General") }
  fab!(:staff_category) { Fabricate(:private_category, name: "Staff", group: Group[:staff]) }

  let(:manifest) { described_class.manifest }
  let!(:uncategorized) { Category.find(SiteSetting.uncategorized_category_id) }

  before do
    SiteSetting.general_category_id = general.id
    SiteSetting.staff_category_id = staff_category.id

    # The state the native upcoming change leaves behind once it is promoted.
    UpcomingChangeEvent.create!(
      upcoming_change_name: "remove_and_replace_uncategorized",
      event_type: :automatically_promoted,
      event_data: {
        uncategorized_category_id: uncategorized.id,
      },
    )
    SiteSetting.uncategorized_category_id = -1
  end

  def status_of(key)
    bootstrap.results.find { |result| result.key == key }&.status
  end

  def acl_of(category)
    category.reload.category_groups.map do |category_group|
      [category_group.group.name, category_group.permission_type]
    end
  end

  def seed_site_feedback
    category =
      Category.new(
        name: "Site Feedback",
        description: "Discussion about this site.",
        user: Discourse.system_user,
      )
    category.set_permissions(everyone: :full)
    category.save!
    SiteSetting.meta_category_id = category.id
    category
  end

  def install_theme(revision:, auto_update: false)
    remote =
      RemoteTheme.create!(
        remote_url: "https://github.com/leo-even/CannLabs-Community-Theme.git",
        local_version: revision,
        remote_version: revision,
      )
    Fabricate(:theme, remote_theme: remote, auto_update:)
  end

  describe "the shipped manifest" do
    it "names groups by technical identity and keeps local-only settings out of the global list" do
      known_groups = manifest["builtin_groups"] + manifest["groups"].keys
      referenced_groups =
        manifest["settings"].values.grep(Array).flatten +
          manifest["categories"].values.flat_map { |definition| definition["permissions"].keys }

      expect(referenced_groups - known_groups).to be_empty
      expect(manifest["settings"].keys).not_to include(*manifest["profile_settings"].keys)
      expect(manifest["profile_settings"]).to eq(
        "user_notes_enabled" => {
          "local" => true,
        },
        "cannlabs_qualified_access_enabled" => {
          "local" => true,
          "production" => true,
        },
        "allow_index_in_robots_txt" => {
          "production" => false,
        },
      )
    end
  end

  describe "search-engine indexing in the production profile" do
    it "passes when indexing is off" do
      SiteSetting.allow_index_in_robots_txt = false

      bootstrap.audit

      expect(status_of("settings.allow_index_in_robots_txt")).to eq(:pass)
    end

    it "reports drift when indexing is on and repairs only that setting, once" do
      SiteSetting.allow_index_in_robots_txt = true

      bootstrap.audit
      expect(status_of("settings.allow_index_in_robots_txt")).to eq(:drift)
      expect(SiteSetting.allow_index_in_robots_txt).to eq(true)

      bootstrap.apply
      expect(SiteSetting.allow_index_in_robots_txt).to eq(false)
      expect(
        bootstrap
          .results
          .find { |result| result.key == "settings.allow_index_in_robots_txt" }
          .changed,
      ).to eq(true)

      bootstrap.apply
      expect(
        bootstrap
          .results
          .find { |result| result.key == "settings.allow_index_in_robots_txt" }
          .changed,
      ).to eq(false)
    end

    it "leaves the setting gated in the local profile" do
      SiteSetting.allow_index_in_robots_txt = true
      local = described_class.new(profile: "local", manifest:)

      local.apply

      expect(
        local.results.find { |result| result.key == "settings.allow_index_in_robots_txt" }.status,
      ).to eq(:gated)
      expect(SiteSetting.allow_index_in_robots_txt).to eq(true)
    end
  end

  describe "Qualified Access in the production profile" do
    before do
      skip("needs LOAD_PLUGINS=1") if !SiteSetting.has_setting?(:cannlabs_qualified_access_enabled)
    end

    def result_for(key)
      bootstrap.results.find { |result| result.key == key }
    end

    it "passes when Qualified Access is enabled" do
      SiteSetting.cannlabs_qualified_access_enabled = true

      bootstrap.audit

      expect(status_of("settings.cannlabs_qualified_access_enabled")).to eq(:pass)
    end

    it "reports drift when disabled and repairs only that setting, once" do
      bootstrap.apply
      SiteSetting.cannlabs_qualified_access_enabled = false

      bootstrap.audit
      expect(status_of("settings.cannlabs_qualified_access_enabled")).to eq(:drift)
      expect(SiteSetting.cannlabs_qualified_access_enabled).to eq(false)

      expect { bootstrap.apply }.not_to change { [GroupUser.count, GroupHistory.count] }
      expect(SiteSetting.cannlabs_qualified_access_enabled).to eq(true)
      expect(bootstrap.results.select(&:changed).map(&:key)).to eq(
        ["settings.cannlabs_qualified_access_enabled"],
      )

      bootstrap.apply
      expect(result_for("settings.cannlabs_qualified_access_enabled").changed).to eq(false)
      expect(bootstrap.results.count(&:changed)).to eq(0)
    end

    it "keeps User Notes gated" do
      SiteSetting.user_notes_enabled = false

      bootstrap.apply

      expect(status_of("settings.user_notes_enabled")).to eq(:gated)
      expect(SiteSetting.user_notes_enabled).to eq(false)
    end
  end

  describe "#audit" do
    it "detects drift on a fresh database without writing anything" do
      expect { bootstrap.audit }.not_to change {
        [
          Group.count,
          Category.count,
          CategoryGroup.count,
          UserHistory.count,
          SiteSetting.login_required,
          SiteSetting.flag_post_allowed_groups,
        ]
      }

      expect(status_of("groups.membros_ativos")).to eq(:drift)
      expect(status_of("settings.login_required")).to eq(:drift)
      expect(status_of("settings.flag_post_allowed_groups")).to eq(:drift)
      expect(status_of("categories.general")).to eq(:drift)
      expect(status_of("categories.comunidade")).to eq(:drift)
      expect(status_of("uncategorized.residual_category")).to eq(:drift)
    end

    it "is blocked while the special Uncategorized category is still active" do
      SiteSetting.uncategorized_category_id = uncategorized.id

      bootstrap.audit

      expect(status_of("uncategorized.special_category")).to eq(:blocked)
      expect(bootstrap.status).to eq(:blocked)
    end

    it "is blocked when the theme or the plugin is not installed" do
      manifest["plugin"]["name"] = "a-plugin-that-is-not-installed"

      bootstrap.audit

      expect(status_of("theme.installed")).to eq(:blocked)
      expect(status_of("plugin.loaded")).to eq(:blocked)
    end
  end

  describe "#apply" do
    it "does not activate a theme installed at another revision" do
      theme = install_theme(revision: "0000000000000000000000000000000000000000")

      bootstrap.apply

      expect(status_of("theme.revision")).to eq(:blocked)
      expect(status_of("theme.default")).to eq(:blocked)
      expect(SiteSetting.default_theme_id).not_to eq(theme.id)
    end

    it "creates the custom groups with staff-controlled membership and no members" do
      bootstrap.apply

      groups = Group.where(name: manifest["groups"].keys)
      expect(groups.pluck(:name)).to match_array(manifest["groups"].keys)
      expect(
        groups.pluck(:public_admission, :public_exit, :allow_membership_requests, :automatic).uniq,
      ).to eq([[false, false, false, false]])
      expect(groups.pluck(:grant_trust_level, :automatic_membership_email_domains).uniq).to eq(
        [[nil, nil]],
      )
      expect(GroupUser.where(group: groups)).to be_empty

      expect(Group.find_by(name: "membros_ativos")).to have_attributes(
        full_name: "Membros da Community",
        visibility_level: Group.visibility_levels[:staff],
        members_visibility_level: Group.visibility_levels[:staff],
      )
      expect(Group.find_by(name: "medicos_verif")).to have_attributes(
        visibility_level: Group.visibility_levels[:logged_on_users],
        members_visibility_level: Group.visibility_levels[:staff],
      )
    end

    it "repairs a custom group that allows self-service membership" do
      group =
        Fabricate(
          :group,
          name: "membros_ativos",
          public_admission: true,
          public_exit: true,
          grant_trust_level: 2,
          visibility_level: Group.visibility_levels[:public],
        )

      bootstrap.apply

      expect(group.reload).to have_attributes(
        public_admission: false,
        public_exit: false,
        grant_trust_level: 0,
        visibility_level: Group.visibility_levels[:staff],
      )
    end

    it "does not add, remove or promote any group member" do
      member = Fabricate(:user)
      owner = Fabricate(:admin)
      group = Fabricate(:group, name: "membros_ativos", public_admission: true)
      group.add(member)
      group.add_owner(owner)

      expect { bootstrap.apply }.not_to change {
        GroupUser.where(group: Group.where(automatic: false)).pluck(:group_id, :user_id, :owner)
      }

      expect(group.reload.public_admission).to eq(false)
      expect(Group.find_by(name: "acesso_profissionais").users).to be_empty
    end

    it "is blocked by a group owner who is not staff and keeps that owner" do
      bootstrap.apply
      group = Group.find_by(name: "liderancas_aprov")
      owner = Fabricate(:user)
      group.add_owner(owner)

      bootstrap.apply

      expect(status_of("groups.liderancas_aprov")).to eq(:blocked)
      expect(group.group_users.where(owner: true).pluck(:user_id)).to eq([owner.id])
    end

    it "reconciles reporting and messaging eligibility by group identity" do
      other_group = Fabricate(:group)
      SiteSetting.flag_post_allowed_groups = "1|2|#{other_group.id}"
      SiteSetting.personal_message_enabled_groups = "1|2|#{Group::AUTO_GROUPS[:trust_level_1]}"

      bootstrap.apply

      expect(SiteSetting.flag_post_allowed_groups_map).to contain_exactly(
        Group::AUTO_GROUPS[:admins],
        Group::AUTO_GROUPS[:moderators],
        Group::AUTO_GROUPS[:trust_level_1],
        Group.find_by(name: "membros_ativos").id,
      )
      expect(SiteSetting.personal_message_enabled_groups_map).to contain_exactly(
        Group::AUTO_GROUPS[:admins],
        Group::AUTO_GROUPS[:moderators],
      )
    end

    it "turns Chat off when it was enabled" do
      skip("needs LOAD_PLUGINS=1") if !SiteSetting.has_setting?(:chat_enabled)
      SiteSetting.chat_enabled = true

      bootstrap.apply

      expect(SiteSetting.chat_enabled).to eq(false)
    end

    it "closes General and the residual Uncategorized category and creates the Community categories" do
      bootstrap.apply

      expect(acl_of(general)).to eq([["membros_ativos", CategoryGroup.permission_types[:full]]])
      expect(acl_of(uncategorized)).to eq(
        [["membros_ativos", CategoryGroup.permission_types[:full]]],
      )
      expect([general, uncategorized].map(&:read_restricted)).to eq([true, true])

      expect(acl_of(Category.find_by(slug: "comunidade"))).to eq(
        [["membros_ativos", CategoryGroup.permission_types[:full]]],
      )
      expect(acl_of(Category.find_by(slug: "profissionais-verificados"))).to eq(
        [["acesso_profissionais", CategoryGroup.permission_types[:full]]],
      )
      expect(acl_of(Category.find_by(slug: "liderancas-de-associacoes"))).to eq(
        [["acesso_liderancas", CategoryGroup.permission_types[:full]]],
      )
    end

    it "removes ordinary members from a qualified category ACL" do
      bootstrap.apply
      professionals = Category.find_by(slug: "profissionais-verificados")
      professionals.set_permissions(acesso_profissionais: :full, membros_ativos: :full)
      professionals.save!

      bootstrap.audit
      expect(status_of("categories.profissionais_verificados")).to eq(:drift)

      bootstrap.apply
      expect(acl_of(professionals)).to eq(
        [["acesso_profissionais", CategoryGroup.permission_types[:full]]],
      )
    end

    it "reports a wrong Staff category ACL without changing it" do
      CategoryGroup.create!(
        category: staff_category,
        group: Group[:trust_level_0],
        permission_type: CategoryGroup.permission_types[:readonly],
      )

      expect { bootstrap.apply }.not_to change { acl_of(staff_category) }

      expect(status_of("categories.staff")).to eq(:blocked)
    end

    it "is blocked by an open category outside the manifest and leaves it alone" do
      open_category = Fabricate(:category)

      bootstrap.apply

      expect(status_of("categories.unmanaged")).to eq(:blocked)
      expect(open_category.reload.read_restricted).to eq(false)
    end

    it "retires the untouched seeded Site Feedback scaffold and tolerates the stale setting" do
      site_feedback = seed_site_feedback
      definition_topic_id = site_feedback.topic_id

      bootstrap.apply

      expect(Category.exists?(site_feedback.id)).to eq(false)
      expect(Topic.exists?(definition_topic_id)).to eq(false)
      expect(SiteSetting.meta_category_id).to eq(site_feedback.id)
      expect(status_of("retired_categories.site_feedback")).to eq(:pass)
    end

    it "refuses to retire Site Feedback when someone posted a topic in it" do
      site_feedback = seed_site_feedback
      Fabricate(:topic, category: site_feedback)

      bootstrap.apply

      expect(Category.exists?(site_feedback.id)).to eq(true)
      expect(status_of("retired_categories.site_feedback")).to eq(:blocked)
    end

    it "refuses to retire Site Feedback when a person edited its definition" do
      site_feedback = seed_site_feedback
      site_feedback.topic.first_post.update!(last_editor_id: Fabricate(:admin).id)

      bootstrap.apply

      expect(Category.exists?(site_feedback.id)).to eq(true)
      expect(status_of("retired_categories.site_feedback")).to eq(:blocked)
    end

    it "never deletes a category only because it is named Site Feedback" do
      lookalike = Fabricate(:category, name: "Site Feedback")

      bootstrap.apply

      expect(Category.exists?(lookalike.id)).to eq(true)
      expect(status_of("retired_categories.site_feedback")).to eq(:pass)
    end

    it "makes the pinned installed theme the default and switches automatic updates off" do
      theme = install_theme(revision: manifest.dig("theme", "revision"), auto_update: true)

      bootstrap.apply

      expect(SiteSetting.default_theme_id).to eq(theme.id)
      expect(theme.reload.auto_update).to eq(false)
    end

    it "applies a profile-gated setting only in the profile that lists it" do
      SiteSetting.invite_only = false
      manifest["profile_settings"] = { "invite_only" => { "local" => true } }

      bootstrap.apply
      expect(status_of("settings.invite_only")).to eq(:gated)
      expect(SiteSetting.invite_only).to eq(false)

      described_class.new(profile: "local", manifest:).apply
      expect(SiteSetting.invite_only).to eq(true)
    end

    it "converges, then changes nothing on a second run" do
      bootstrap.apply

      owned = bootstrap.results.reject { |result| result.key.start_with?("theme.", "plugin.") }
      expect(owned.map(&:status).uniq - [:gated]).to eq([:pass])

      expect { bootstrap.apply }.not_to change {
        [
          UserHistory.count,
          GroupHistory.count,
          Group.maximum(:updated_at),
          Category.maximum(:updated_at),
          CategoryGroup.maximum(:id),
        ]
      }
      expect(bootstrap.results.count(&:changed)).to eq(0)
      expect(bootstrap.report).to end_with("NO CHANGE")
    end
  end

  describe ".run" do
    let(:output) { StringIO.new }

    it "audits by default and returns the blocked exit code when prerequisites are missing" do
      exit_code = described_class.run(profile: "production", format: "json", out: output)

      expect(exit_code).to eq(2)
      expect(JSON.parse(output.string)).to include("mode" => "audit", "status" => "blocked")
      expect(Group.exists?(name: "membros_ativos")).to eq(false)
    end

    it "refuses an unknown profile with a usage exit code" do
      exit_code = described_class.run(profile: nil, apply: true, out: output)

      expect(exit_code).to eq(3)
      expect(output.string).to include("PROFILE must be one of: local, production")
      expect(Group.exists?(name: "membros_ativos")).to eq(false)
    end
  end
end
