# frozen_string_literal: true

RSpec.describe "CannLabs path secret redaction" do
  # Synthetic, hex-only so it satisfies the routes that constrain their token (/session/otp/:token).
  secret = "cafe0123deadbeef4567"
  filtered = "[FILTERED]"

  def request_for(path_and_query)
    ActionDispatch::Request.new(
      Rack::MockRequest.env_for(path_and_query).merge(Rails.application.env_config),
    )
  end

  def filtered_path_for(path_and_query)
    request_for(path_and_query).filtered_path
  end

  # Rack::MockRequest.env_for reads a leading "//x" as a URI authority, so paths that must reach
  # the request exactly as written are set on the env directly.
  def filtered_path_info(path_info)
    env = Rack::MockRequest.env_for("/").merge(Rails.application.env_config)
    env["PATH_INFO"] = path_info
    ActionDispatch::Request.new(env).filtered_path
  end

  # Credential-bearing core route families: the prefix before the secret.
  credential_prefixes =
    %w[u users].flat_map do |root|
      %w[
        password-reset
        confirm-email-token
        activate-account
        confirm-old-email
        confirm-new-email
        confirm-admin
      ].map { |name| "/#{root}/#{name}/" }
    end +
      %w[
        /session/email-login/
        /session/otp/
        /associate/
        /invites/
        /invites/show/
        /email/unsubscribe/
      ]

  describe "request path" do
    credential_prefixes.each do |prefix|
      it "redacts the secret in #{prefix}:secret" do
        expect(filtered_path_for("#{prefix}#{secret}")).to eq("#{prefix}#{filtered}")
      end
    end

    it "keeps a format suffix" do
      expect(filtered_path_for("/users/activate-account/#{secret}.json")).to eq(
        "/users/activate-account/#{filtered}.json",
      )
    end

    it "composes with the query string filters" do
      path = filtered_path_for("/u/password-reset/#{secret}?token=#{secret}&country_code=AU")

      expect(path).to eq("/u/password-reset/#{filtered}?token=#{filtered}&country_code=AU")
    end

    it "redacts the normalized forms of a credential path" do
      [
        "//u//password-reset/#{secret}",
        "/u/password%2Dreset/#{secret}",
        "/%75/password-reset/#{secret}",
        "/u/password-reset/#{secret}/",
        "/u/password-reset/#{secret[0, 8]}%2E#{secret[8..]}",
      ].each do |path|
        logged = filtered_path_info(path)

        expect(logged).to include(filtered)
        expect(logged).not_to include(secret[0, 8])
        expect(logged).not_to include(secret[8..])
      end
    end

    it "does not raise on invalid bytes, and still redacts" do
      logged = filtered_path_info("/u/password-reset/\xFF\xFE#{secret}".b)

      expect(logged).not_to include(secret)
      expect(logged).to include(filtered)
    end

    it "leaves paths without a credential untouched" do
      %w[
        /t/some-topic/12
        /t/some-topic/12?page=2
        /u/password-reset
        /u/password-reset/
        /u/some-user
        /u/admin-login
        /session/csrf
        /email/unsubscribe
      ].each { |path| expect(filtered_path_for(path)).to eq(path) }
    end

    it "covers every credential-bearing core route that has a :token segment" do
      core_token_routes =
        Rails.application.routes.routes.select do |route|
          controller = route.defaults[:controller]
          route.path.spec.to_s.include?(":token") && controller.present? &&
            Rails.root.join("app/controllers/#{controller}_controller.rb").exist?
        end

      expect(core_token_routes).not_to be_empty

      uncovered =
        core_token_routes.filter_map do |route|
          path = route.path.spec.to_s.gsub(/\([^)]*\)/, "").gsub(":token", secret).gsub(/:\w+/, "x")
          path if filtered_path_for(path).include?(secret)
        end

      expect(uncovered).to be_empty,
      "Core routes carry a :token in the path that is not covered by " \
        "CannlabsPathSecretRedaction::RULES (add it, and its nginx counterpart): #{uncovered.join(", ")}"
    end

    it "still finds the routes whose id or key is the credential" do
      paths = Rails.application.routes.routes.map { |route| route.path.spec.to_s }

      expect(paths).to include(
        a_string_starting_with("/invites/:id"),
        a_string_starting_with("/invites/show/:id"),
        a_string_starting_with("/email/unsubscribe/:key"),
      )
    end
  end

  describe "parameter log" do
    let(:parameter_filter) do
      ActiveSupport::ParameterFilter.new(Rails.application.config.filter_parameters)
    end

    it "filters the invite key (invites#id)" do
      params = { "controller" => "invites", "action" => "show", "id" => +secret }

      expect(parameter_filter.filter(params)["id"]).to eq(filtered)
    end

    it "filters the unsubscribe key (email#key)" do
      params = { "controller" => "email", "action" => "unsubscribe", "key" => +secret }

      expect(parameter_filter.filter(params)["key"]).to eq(filtered)
    end

    it "filters frozen values too" do
      params = { "controller" => "invites", "action" => "show", "id" => secret.dup.freeze }

      expect(parameter_filter.filter(params)["id"]).to eq(filtered)
    end

    it "keeps ordinary ids visible" do
      topic = { "controller" => "topics", "action" => "show", "id" => "12", "topic_id" => "12" }
      invites = { "controller" => "invites", "action" => "create", "topic_id" => "12" }
      email = { "controller" => "email", "action" => "unsubscribe", "id" => "12" }

      expect(parameter_filter.filter(topic)).to eq(topic)
      expect(parameter_filter.filter(invites)).to eq(invites)
      expect(parameter_filter.filter(email)).to eq(email)
    end

    it "keeps the Task 36 key filters" do
      params = { "controller" => "session", "token" => +secret, "country_code" => "AU" }
      result = parameter_filter.filter(params)

      expect(result["token"]).to eq(filtered)
      expect(result["country_code"]).to eq("AU")
    end
  end

  describe "request logging" do
    # Specs run with Lograge enabled (spec/rails_helper.rb), and the lograge gem replaces
    # Rails::Rack::Logger#call_app, which omits this line. Production-like does not load it. So the
    # middleware's own message builder (documented, `# :doc:`) is exercised directly: it is what
    # prints "Started GET ..." and it reads the request's filtered_path.
    it "builds the request line from the redacted path" do
      request = request_for("/u/password-reset/#{secret}?token=#{secret}&country_code=AU")
      message =
        Rails::Rack::Logger.new(->(_env) { [200, {}, ["ok"]] }).send(
          :started_request_message,
          request,
        )

      expect(message).to include(
        "Started GET \"/u/password-reset/#{filtered}?token=#{filtered}&country_code=AU\"",
      )
      expect(message).not_to include(secret)
    end

    describe "controller instrumentation", type: :request do
      it "carries no secret in the processing path or parameters" do
        payloads = []
        subscriber =
          ActiveSupport::Notifications.subscribe("start_processing.action_controller") do |*args|
            payloads << args.last
          end

        get "/email/unsubscribe/#{secret}?token=#{secret}&country_code=AU"

        # The payload also holds the request object itself, whose env legitimately has the raw
        # path. Only what the log subscribers print is asserted on.
        logged = payloads.map { |payload| payload.slice(:path, :params) }

        expect(payloads).not_to be_empty
        expect(logged.to_json).not_to include(secret)
        expect(payloads.first[:path]).to start_with("/email/unsubscribe/#{filtered}")
        expect(payloads.first[:params]["key"]).to eq(filtered)
        expect(payloads.first[:params]["country_code"]).to eq("AU")
      ensure
        ActiveSupport::Notifications.unsubscribe(subscriber)
      end
    end
  end
end
