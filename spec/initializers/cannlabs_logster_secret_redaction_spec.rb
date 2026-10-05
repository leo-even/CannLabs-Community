# frozen_string_literal: true

require "logster/middleware/reporter"

RSpec.describe "CannLabs Logster secret redaction" do
  sensitive = %w[
    code
    state
    token
    access_token
    refresh_token
    id_token
    client_secret
    authenticity_token
  ]
  secrets = (sensitive + %w[path referer]).index_with { |name| "cannlabs-secret-#{name}-4f9a" }
  filtered = "[FILTERED]"

  def web_env(path_and_query, referer: nil)
    options = { "REQUEST_URI" => path_and_query, "HTTP_HOST" => "community.example" }
    options["HTTP_REFERER"] = referer if referer
    Rack::MockRequest.env_for(path_and_query, options)
  end

  def expect_no_secrets(payload, secrets)
    secrets.each_value { |value| expect(payload).not_to include(value) }
  end

  let(:oauth_query) do
    (sensitive.map { |name| "#{name}=#{secrets[name]}" } + %w[country_code=AU]).join("&")
  end
  let(:secret_referer) do
    "https://community.example/u/password-reset/#{secrets["path"]}?code=#{secrets["referer"]}"
  end

  it "patches the Logster extension point it relies on" do
    expect(Logster::Message).to respond_to(:populate_env_helper)
    expect(Logster::Message).to respond_to(:populate_from_env)
    expect(Logster::Message.singleton_class.ancestors).to include(CannlabsLogsterSecretRedaction)
  end

  it "scrubs an OAuth-shaped callback request" do
    env = web_env("/auth/google_oauth2/callback?#{oauth_query}", referer: secret_referer)
    stored = Logster::Message.populate_from_env(env)

    sensitive.each do |name|
      expect(stored["REQUEST_URI"]).to include("#{name}=#{filtered}")
      expect(stored["params"][name]).to eq(filtered)
    end
    expect_no_secrets(stored.to_json, secrets)
  end

  it "keeps ordinary metadata, including the non-sensitive control" do
    env = web_env("/auth/google_oauth2/callback?#{oauth_query}", referer: secret_referer)
    stored = Logster::Message.populate_from_env(env)

    expect(stored["REQUEST_URI"]).to start_with("/auth/google_oauth2/callback?")
    expect(stored["REQUEST_URI"]).to include("country_code=AU")
    expect(stored["params"]["country_code"]).to eq("AU")
    expect(stored["HTTP_HOST"]).to eq("community.example")
  end

  it "scrubs a credential-bearing path" do
    env = web_env("/u/password-reset/#{secrets["path"]}?token=#{secrets["token"]}")
    stored = Logster::Message.populate_from_env(env)

    expect(stored["REQUEST_URI"]).to eq("/u/password-reset/#{filtered}?token=#{filtered}")
    expect_no_secrets(stored.to_json, secrets)
  end

  it "reduces the Referer to its origin" do
    env = web_env("/", referer: secret_referer)

    expect(Logster::Message.populate_from_env(env)["HTTP_REFERER"]).to eq(
      "https://community.example",
    )
  end

  it "does not keep a Referer that is not an http(s) URL" do
    env = web_env("/", referer: "android-app://com.example/#{secrets["referer"]}")
    stored = Logster::Message.populate_from_env(env)

    expect(stored["HTTP_REFERER"]).to eq("-")
    expect_no_secrets(stored.to_json, secrets)
  end

  it "keeps passwords redacted" do
    stored = Logster::Message.populate_from_env(web_env("/session?password=hunter2"))

    # Logster redacts it first; Rails' own :passw filter then masks it with its usual marker.
    expect(stored["params"]["password"]).to eq(filtered)
    expect(stored.to_json).not_to include("hunter2")
  end

  it "leaves a non-request environment unchanged" do
    env = { "hostname" => "web-1", :current_db => "default" }

    expect(Logster::Message.populate_from_env(env)).to eq(env)
  end

  it "stores no secret when a message is logged while a request is served" do
    logger = Logster::Logger.new(Logster.store)
    app =
      lambda do |_env|
        logger.error("cannlabs synthetic OAuth callback failure")
        [200, {}, ["ok"]]
      end

    Logster::Middleware::Reporter.new(app).call(
      web_env("/auth/google_oauth2/callback?#{oauth_query}", referer: secret_referer),
    )

    message =
      Logster
        .store
        .latest(limit: 50)
        .find do |candidate|
          candidate.message.include?("cannlabs synthetic OAuth callback failure")
        end

    expect(message).to be_present
    expect_no_secrets(message.to_json, secrets)
    expect(message.to_json).to include("country_code=AU")
  end
end
