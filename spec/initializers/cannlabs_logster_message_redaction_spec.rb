# frozen_string_literal: true

RSpec.describe "CannLabs Logster message redaction" do
  filtered = "[FILTERED]"
  secret = "cannlabs-secret-message-3c8d"
  other_secret = "cannlabs-secret-state-6e72"

  def route_miss(path)
    %(ActionController::RoutingError (No route matches [GET] "#{path}"))
  end

  def redact(text) = CannlabsLogsterMessageRedaction.redact(text)

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

  # What the wrapper sits in front of.
  def upstream = Logster::Logger.instance_method(:add_with_opts).super_method

  let(:logger) { Logster::Logger.new(Logster.store) }

  before { Logster.store.clear_all }

  it "wraps Logster::Logger#add_with_opts from a file called logger.rb" do
    wrapper = Logster::Logger.instance_method(:add_with_opts)

    expect(wrapper.owner).to eq(CannlabsLogsterMessageRedaction)
    expect(wrapper.source_location.first).to end_with("/logger.rb")
    expect(upstream.owner).to eq(Logster::Logger)
    expect(upstream.parameters).to eq(CannlabsLogsterMessageRedaction::SIGNATURE)
  end

  it "loads the redaction rules it relies on" do
    expect(CannlabsLogMessageRedaction).to respond_to(:message)
    expect(CannlabsLogMessageRedaction).to respond_to(:location)
    expect(CannlabsPathSecretRedaction::RULES).to be_present
  end

  describe "ordinary text" do
    samples = [
      "Job exception: connection to server at \"10.0.0.2\", port 5432 failed: timeout expired",
      "PG::UniqueViolation: ERROR: duplicate key value violates unique constraint \"index_users\"",
      "ActiveRecord::RecordNotFound (Couldn't find Topic with 'id'=12345)\n/app/a.rb:1:in 'x'",
      "Uncaught TypeError: Cannot read properties of undefined\nLine: 12\nColumn: 4",
      "Started GET \"/latest.json?page=2&country_code=AU\" for 10.0.0.1",
      "see https://example.com/assets/app.js?v=3 and /var/www/discourse/lib/foo.rb:12:in 'bar'",
      "No route matches {:action=>\"show\", :controller=>\"topics\"}",
      "invalid %-encoding is what this message describes",
      "country_code=AU",
      "",
    ]

    it "is returned as the same object" do
      samples.each { |text| expect(redact(text)).to equal(text) }
    end

    it "is returned as the same object for every server message" do
      strings = []
      collect =
        lambda do |value|
          case value
          when Hash
            value.each_value(&collect)
          when Array
            value.each(&collect)
          when String
            strings << value
          end
        end
      collect.call(
        YAML.safe_load_file(
          Rails.root.join("config/locales/server.en.yml").to_s,
          permitted_classes: [Symbol],
          aliases: true,
        ),
      )

      # Email templates spell out the credential path of the link they will contain.
      changed = strings.reject { |text| redact(text).equal?(text) }
      expect(strings.size).to be > 1000
      expect(changed).to all(match(CannlabsLogsterMessageRedaction.credential_path))
    end

    it "is stored unchanged, with its progname" do
      logger.add_with_opts(Logger::ERROR, "cannlabs harmless #{samples[4]}", "app-progname")

      message = find_message("cannlabs harmless")
      expect(message.message).to eq("cannlabs harmless #{samples[4]}")
      expect(message.progname).to eq("app-progname")
    end

    it "passes the same message object to the subscribers" do
      text = +"cannlabs harmless subscriber text"
      received = nil
      logger.subscribe { |_severity, message, *| received = message }

      logger.add_with_opts(Logger::ERROR, text, "prog")

      expect(received).to equal(text)
    end

    it "keeps an invalid encoding for Logster to scrub" do
      text = "cannlabs bad \xFF bytes".dup.force_encoding("UTF-8")

      expect(redact(text)).to equal(text)
      logger.add_with_opts(Logger::ERROR, text, "prog")
      expect(find_message("cannlabs bad").message).to eq(text.scrub)
    end
  end

  describe "request-derived credentials" do
    it "redacts a credential path in a router miss" do
      expect(redact(route_miss("/associate/#{secret}"))).to eq(route_miss("/associate/#{filtered}"))
    end

    it "redacts a credential path in text" do
      text =
        "cannlabs sensitive path: redirected to https://community.example/u/password-reset/#{secret}."

      expect(redact(text)).to eq(
        "cannlabs sensitive path: redirected to https://community.example/u/password-reset/#{filtered}.",
      )
    end

    it "redacts sensitive query parameters in text and keeps the others" do
      text =
        "cannlabs callback failed: /auth/google_oauth2/callback?code=#{secret}&state=#{other_secret}&country_code=AU"

      redacted = redact(text)
      expect(redacted).to eq(
        "cannlabs callback failed: /auth/google_oauth2/callback?code=#{filtered}&state=#{filtered}&country_code=AU",
      )
    end

    it "redacts the fragment of a malformed percent-encoding" do
      text = "ArgumentError (invalid %-encoding (%zz#{secret}(x)))\n/app/a.rb:1:in 'x'"

      expect(redact(text)).to eq("ArgumentError (invalid %-encoding (#{filtered})")
    end

    it "is applied again without effect" do
      [
        route_miss("/associate/#{secret}"),
        "ArgumentError (invalid %-encoding (%zz#{secret}))",
        "/auth/callback?code=#{secret}&country_code=AU",
      ].each do |text|
        once = redact(text)
        expect(redact(once)).to eq(once)
      end
    end

    it "stores the redacted text, and groups what differs only by the secret" do
      allow(Logster.config).to receive(:allow_grouping).and_return(true)

      3.times do |index|
        logger.add_with_opts(
          Logger::ERROR,
          "cannlabs-grouped #{route_miss("/associate/#{secret}#{index}")}",
          "web-exception",
          backtrace: "/app/x.rb:1",
        )
      end
      3.times do |index|
        logger.add_with_opts(
          Logger::ERROR,
          "cannlabs-distinct id=#{index}",
          "web-exception",
          backtrace: "/app/x.rb:1",
        )
      end

      messages = Logster.store.latest(limit: 50)
      grouped = messages.select { |message| message.message.include?("cannlabs-grouped") }
      expect(grouped.size).to eq(1)
      expect(grouped.first.count).to eq(3)
      expect(grouped.first.to_json).not_to include(secret)
      expect(messages.count { |message| message.message.include?("cannlabs-distinct") }).to eq(3)
    end

    it "is the contract of the production ignore list too" do
      # These patterns are why Logster drops request-derived BadRequest and RoutingError text before it
      # is stored. A change upstream must not silently re-expose it.
      source = Rails.root.join("config/initializers/100-logster.rb").read
      patterns = [
        %r{/\^ActionController::BadRequest/},
        %r{/Rack::QueryParser::InvalidParameterError/},
        %r{/\^ActionController::RoutingError \\\(No route matches/},
      ]
      patterns.each { |pattern| expect(source).to match(pattern) }

      ignore = [
        /^ActionController::BadRequest/,
        /Rack::QueryParser::InvalidParameterError/,
        /^ActionController::RoutingError \(No route matches/,
      ]
      [
        "ActionController::BadRequest (Invalid request parameters: invalid %-encoding (%zz#{secret}))\n/app/a.rb:1",
        "Rack::QueryParser::InvalidParameterError (invalid %-encoding (%zz#{secret}))\n/app/a.rb:1",
        "#{route_miss("/associate/#{secret}")}\n/app/a.rb:1",
      ].each do |text|
        expect(ignore.map { |pattern| text.match?(pattern) }).to eq(
          ignore.map { |pattern| redact(text).match?(pattern) },
        )
        expect(ignore.any? { |pattern| redact(text).match?(pattern) }).to eq(true)
      end
    end
  end

  describe "text that arrives through progname" do
    it "redacts Rails.logger.warn(\"text\")" do
      logger.warn("cannlabs-progname #{route_miss("/associate/#{secret}")}")

      message = find_message("cannlabs-progname")
      expect(message.message).to eq("cannlabs-progname #{route_miss("/associate/#{filtered}")}")
      expect(message.to_json).not_to include(secret)
    end

    it "redacts it when recording fails" do
      allow(Logster.store).to receive(:save).and_raise("cannlabs store unavailable")

      stderr =
        capture_stderr { logger.error("cannlabs-progname #{route_miss("/associate/#{secret}")}") }

      expect(stderr).to include("Failed to report error: cannlabs store unavailable")
      expect(stderr).not_to include(secret)
    end

    it "leaves an ordinary progname alone" do
      logger.add_with_opts(Logger::ERROR, "cannlabs ordinary message", "discourse-warning")

      expect(find_message("cannlabs ordinary message").progname).to eq("discourse-warning")
    end
  end

  describe "a block" do
    def wired_logger
      Logster::Logger
        .new(Logster.store)
        .tap do |wired|
          wired.subscribe { |_severity, _message, _progname, _opts, &block| block&.call }
          wired.chain(::Logger.new(StringIO.new))
        end
    end

    it "is not evaluated below the active level" do
      evaluations = 0
      logger.level = Logger::ERROR

      result =
        logger.warn do
          evaluations += 1
          "cannlabs never evaluated"
        end

      expect(evaluations).to eq(0)
      expect(result).to eq(true)
      expect(find_message("cannlabs never evaluated")).to be_nil
    end

    it "is evaluated exactly as often as without the wrapper" do
      counted =
        proc do |counter|
          proc do
            counter[0] += 1
            "cannlabs block text"
          end
        end

      wrapped = [0]
      wired_logger.add_with_opts(Logger::ERROR, nil, nil, nil, &counted.call(wrapped))
      plain = [0]
      upstream.bind_call(wired_logger, Logger::ERROR, nil, nil, nil, &counted.call(plain))

      expect(plain[0]).to be > 1
      expect(wrapped[0]).to eq(plain[0])
    end

    it "is redacted when it is evaluated" do
      logger.add_with_opts(Logger::ERROR, nil, nil, nil) do
        "cannlabs-block #{route_miss("/associate/#{secret}")}"
      end

      message = find_message("cannlabs-block")
      expect(message.message).to eq("cannlabs-block #{route_miss("/associate/#{filtered}")}")
    end

    it "is redacted when recording fails" do
      allow(Logster.store).to receive(:save).and_raise("cannlabs store unavailable")

      stderr =
        capture_stderr do
          logger.add_with_opts(Logger::ERROR, nil, nil, nil) { route_miss("/associate/#{secret}") }
        end

      expect(stderr).to include("Failed to report error: cannlabs store unavailable")
      expect(stderr).not_to include(secret)
    end

    it "behaves like upstream when it raises" do
      failing = proc { raise "cannlabs block failure" }

      wrapped = capture_stderr { logger.add_with_opts(Logger::ERROR, nil, "prog", nil, &failing) }
      plain =
        capture_stderr { upstream.bind_call(logger, Logger::ERROR, nil, "prog", nil, &failing) }

      expect(wrapped).to include("Failed to report error: cannlabs block failure")
      expect(wrapped).to eq(plain)
    end

    it "passes on what is not text" do
      logger.add_with_opts(Logger::ERROR, nil, nil, nil) { 42 }

      expect(Logster.store.latest(limit: 5).map(&:message)).to include("42")
    end
  end

  describe "when recording fails" do
    let(:request_text) { "cannlabs-failing #{route_miss("/associate/#{secret}")}\n/app/a.rb:1" }

    it "does not print a credential path when the store fails" do
      allow(Logster.store).to receive(:save).and_raise("cannlabs store unavailable")

      stderr = capture_stderr { logger.add_with_opts(Logger::ERROR, request_text, "web-exception") }

      expect(stderr).to include("Failed to report error: cannlabs store unavailable")
      expect(stderr).to include(%(No route matches [GET] "/associate/#{filtered}"))
      expect(stderr).not_to include(secret)
    end

    it "does not print a credential path when counting an ignored message fails" do
      allow(Logster.store).to receive(:ignore).and_return(
        [/^cannlabs-failing ActionController::RoutingError/],
      )
      allow(Logster.store).to receive(:increment_ignore_count).and_raise(
        "cannlabs redis unavailable",
      )

      stderr = capture_stderr { logger.add_with_opts(Logger::ERROR, request_text, "web-exception") }

      expect(stderr).to include("Failed to report error: cannlabs redis unavailable")
      expect(stderr).not_to include(secret)
    end

    it "does not print the fragment of a malformed percent-encoding" do
      allow(Logster.store).to receive(:save).and_raise("cannlabs store unavailable")

      stderr =
        capture_stderr do
          logger.add_with_opts(
            Logger::ERROR,
            "cannlabs-failing ArgumentError (invalid %-encoding (%zz#{secret}))",
            "web-exception",
          )
        end

      expect(stderr).to include("cannlabs store unavailable")
      expect(stderr).not_to include(secret)
    end

    it "still reports a failure of Logster itself, without the secret" do
      allow(Logster::Message).to receive(:default_env).and_raise("cannlabs internal failure")

      stderr = capture_stderr { logger.add_with_opts(Logger::ERROR, request_text, "web-exception") }

      expect(stderr).to include("Failed to report error: cannlabs internal failure")
      expect(stderr).not_to include(secret)
    end

    it "does not print the text a failing subscriber was given" do
      logger.subscribe do |_severity, message, progname, *|
        raise "cannlabs subscriber rejected #{message}#{progname}"
      end

      stderr = capture_stderr { logger.add_with_opts(Logger::ERROR, request_text, "web-exception") }

      expect(stderr).to include(
        "Failed to report message to subscriber: RuntimeError (cannlabs subscriber rejected",
      )
      expect(stderr).not_to include(secret)
    end

    it "does not print the text a failing chained logger was given" do
      sink =
        Class.new do
          def add(*arguments) =
            raise("cannlabs chained logger rejected #{arguments[1]}#{arguments[2]}")
        end
      logger.chain(sink.new)

      stderr = capture_stderr { logger.add_with_opts(Logger::ERROR, request_text, "web-exception") }

      expect(stderr).to include(
        "Failed to report message to chained logger: RuntimeError (cannlabs chained logger rejected",
      )
      expect(stderr).not_to include(secret)
    end
  end

  describe "when its own redaction fails" do
    it "withholds the text instead of raising or passing it on" do
      allow(CannlabsLogMessageRedaction).to receive(:message).and_raise(
        "cannlabs redaction failure",
      )

      stderr =
        capture_stderr do
          logger.add_with_opts(Logger::ERROR, "cannlabs-withheld #{secret}", "web-exception")
        end

      expect(stderr).to eq("")
      expect(Logster.store.latest(limit: 5).map(&:message)).to eq(
        [CannlabsLogsterMessageRedaction::WITHHELD],
      )
    end
  end

  describe "everything else Logster does" do
    it "returns what upstream returns" do
      expect(logger.add_with_opts(Logger::ERROR, "cannlabs returns", "prog")).to be_a(
        Logster::Message,
      )

      logger.level = Logger::ERROR
      expect(logger.add_with_opts(Logger::WARN, "cannlabs below the logger level", "prog")).to eq(
        true,
      )
      expect(find_message("cannlabs below the logger level")).to be_nil
    end

    it "keeps the progname of the logger when none is given" do
      logger.progname = "cannlabs-logger-progname"
      logger.add_with_opts(Logger::ERROR, "cannlabs default progname")

      expect(find_message("cannlabs default progname").progname).to eq("cannlabs-logger-progname")
    end

    it "still binds the request env of the current thread" do
      Thread.current[Logster::Logger::LOGSTER_ENV] = Rack::MockRequest.env_for(
        "/auth/callback?code=#{secret}&country_code=AU",
        "REQUEST_URI" => "/auth/callback?code=#{secret}&country_code=AU",
        "HTTP_HOST" => "community.example",
      )

      logger.error("cannlabs thread env")

      env = find_message("cannlabs thread env").env
      expect(env["REQUEST_URI"]).to eq("/auth/callback?code=#{filtered}&country_code=AU")
      expect(env.to_json).not_to include(secret)
    ensure
      Thread.current[Logster::Logger::LOGSTER_ENV] = nil
    end

    it "does not add its own frames to a backtrace taken from the caller" do
      logger.warn("cannlabs backtrace")

      backtrace = find_message("cannlabs backtrace").backtrace
      expect(backtrace.lines.first).to include(File.basename(__FILE__))
      expect(backtrace).not_to include("zz-cannlabs-logster-message-redaction")
    end
  end
end
