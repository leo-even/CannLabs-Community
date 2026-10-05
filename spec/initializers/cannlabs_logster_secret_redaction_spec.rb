# frozen_string_literal: true

require "logster/middleware/debug_exceptions"
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

  describe "when the request params cannot be parsed" do
    marker = CannlabsLogsterSecretRedaction::PARAMS_UNAVAILABLE
    parse_error = "Rack::QueryParser::InvalidParameterError"
    fragment = "cannlabs-secret-fragment-9b3e"
    form = "application/x-www-form-urlencoded"

    def post_env(body, content_type: "application/x-www-form-urlencoded")
      Rack::MockRequest.env_for(
        "/session",
        :method => "POST",
        :input => body,
        "CONTENT_TYPE" => content_type,
        "REQUEST_URI" => "/session",
        "HTTP_HOST" => "community.example",
      )
    end

    # Rack::MockRequest cannot build a request line with a malformed escape, so the query is set directly.
    def query_env(query)
      env = web_env("/session")
      env["QUERY_STRING"] = query
      env["REQUEST_URI"] = "/session?#{query}"
      env
    end

    def failure_class(env)
      Rack::Request.new(env).params
      nil
    rescue StandardError => failure
      failure.class.to_s
    end

    # Logster writes to the STDERR constant, so only the real file descriptor shows what reached the
    # container's log.
    def capture_stderr
      original = STDERR.dup
      Tempfile.create("cannlabs-stderr") do |file|
        STDERR.reopen(file)
        begin
          yield
        ensure
          STDERR.flush
          STDERR.reopen(original)
          original.close
        end
        file.rewind
        file.read
      end
    end

    def find_message(text)
      Logster.store.latest(limit: 50).find { |candidate| candidate.message.include?(text) }
    end

    let(:logger) { Logster::Logger.new(Logster.store) }

    it "stores a marker, and no params, for a malformed form body" do
      stored = Logster::Message.populate_from_env(post_env("login=x&password=%zz#{fragment}(x)"))

      expect(stored).not_to have_key("params")
      expect(stored[marker]).to eq(parse_error)
      expect(stored["REQUEST_URI"]).to eq("/session")
      expect(stored["HTTP_HOST"]).to eq("community.example")
      expect(stored.to_json).not_to include(fragment)
    end

    it "keeps the sanitized URI and Referer when the query is malformed" do
      env = query_env("code=%zz#{fragment}&country_code=AU")
      env["HTTP_REFERER"] = secret_referer
      stored = Logster::Message.populate_from_env(env)

      expect(stored).not_to have_key("params")
      expect(stored[marker]).to eq(parse_error)
      expect(stored["REQUEST_URI"]).to eq("/session?code=#{filtered}&country_code=AU")
      expect(stored["HTTP_REFERER"]).to eq("https://community.example")
      expect_no_secrets(stored.to_json, secrets.merge("fragment" => fragment))
    end

    it "does not write the fragment to stderr, and still stores the event" do
      env = post_env("login=x&password=%zz#{fragment}(x)")
      stderr =
        capture_stderr do
          logger.add_with_opts(
            Logger::ERROR,
            "cannlabs unparsable params",
            "web-exception",
            env: env,
          )
        end

      expect(stderr).to eq("")
      message = find_message("cannlabs unparsable params")
      expect(message.env[marker]).to eq(parse_error)
      expect(message.to_json).not_to include(fragment)
    end

    it "does not change the response or the exception of a request with a malformed body" do
      allow(Logster).to receive(:logger).and_return(logger)
      app =
        lambda do |env|
          ActionDispatch::Request.new(env).POST
          [200, {}, ["ok"]]
        end
      stack =
        Logster::Middleware::Reporter.new(
          ActionDispatch::ShowExceptions.new(
            Logster::Middleware::DebugExceptions.new(app, Rails.application),
            Rails.application.config.exceptions_app,
          ),
        )
      env = post_env("login=x&password=%zz#{fragment}(x)").merge(Rails.application.env_config)

      status = nil
      stderr = capture_stderr { status, = stack.call(env) }

      expect(status).to eq(400)
      expect(env["action_dispatch.exception"]).to be_a(ActionController::BadRequest)
      expect(stderr).to eq("")
    end

    it "does not report a request without params as unavailable" do
      stored = Logster::Message.populate_from_env(post_env(""))

      expect(stored).not_to have_key(marker)
      expect(stored).not_to have_key("params")
    end

    {
      "a parameter type conflict" => -> { post_env("a=1&a[b]=#{fragment}") },
      "nesting beyond the depth limit" => -> { post_env("a#{"[b]" * 120}=#{fragment}") },
      "a key that is not valid UTF-8" => -> { post_env("%FF%FE=#{fragment}") },
      "a truncated multipart body" => -> do
        post_env(
          "--AaB03x\r\nContent-Disposition: form-data; name=\"f\"\r\n\r\n#{fragment}",
          content_type: "multipart/form-data; boundary=AaB03x",
        )
      end,
      "a closed rack.input" => -> do
        post_env("login=x&token=#{fragment}").tap do |env|
          input = StringIO.new("login=x&token=#{fragment}")
          input.close
          env["rack.input"] = input
        end
      end,
      "no rack.input" => -> { post_env("login=x&token=#{fragment}").merge("rack.input" => nil) },
      "a frozen env" => -> { post_env("login=x&country_code=AU&a=#{fragment}").freeze },
    }.each do |description, build|
      it "contains #{description}" do
        expected = failure_class(instance_exec(&build))
        expect(expected).to be_present

        stored = Logster::Message.populate_from_env(instance_exec(&build))

        expect(stored[marker]).to eq(expected)
        expect(stored).not_to have_key("params")
        expect(stored.to_json).not_to include(fragment)
      end
    end

    it "does not swallow a failure of Logster's own env" do
      allow(Logster::Message).to receive(:default_env).and_raise("cannlabs internal failure")

      [post_env("login=x"), post_env("login=x&password=%zz#{fragment}(x)")].each do |env|
        expect { Logster::Message.populate_from_env(env) }.to raise_error(
          "cannlabs internal failure",
        )
      end
    end

    it "does not swallow a failure of the scrub" do
      allow(CannlabsPathSecretRedaction).to receive(:redact).and_raise("cannlabs scrub failure")

      [post_env("login=x"), post_env("login=x&password=%zz#{fragment}(x)")].each do |env|
        expect { Logster::Message.populate_from_env(env) }.to raise_error("cannlabs scrub failure")
      end
    end

    it "leaves a failure of the store to Logster's own handling" do
      allow(Logster.store).to receive(:save).and_raise("cannlabs store failure")
      env = post_env("login=x&password=%zz#{fragment}(x)")

      stderr =
        capture_stderr do
          logger.add_with_opts(Logger::ERROR, "cannlabs store failing", "web-exception", env: env)
        end

      expect(stderr).to include("Failed to report error: cannlabs store failure")
      expect(stderr).not_to include(fragment)
    end

    it "parses a valid request once, as Logster would" do
      parser = Rack::Utils.default_query_parser
      calls = 0
      allow(parser).to receive(:parse_nested_query).and_wrap_original do |original, *arguments|
        calls += 1
        original.call(*arguments)
      end
      valid = -> do
        web_env("/auth/callback?#{oauth_query}").merge("rack.input" => StringIO.new("a=1"))
      end

      Rack::Request.new(valid.call).params
      baseline = calls
      calls = 0
      Logster::Message.populate_from_env(valid.call)

      expect(baseline).to be > 0
      expect(calls).to eq(baseline)
    end

    it "does not mark a valid request" do
      stored = Logster::Message.populate_from_env(post_env("login=x&country_code=AU"))

      expect(stored).not_to have_key(marker)
      expect(stored["params"]["country_code"]).to eq("AU")
    end
  end
end
