# frozen_string_literal: true

# Specs run with Lograge enabled (spec/rails_helper.rb), which unsubscribes ActionController::LogSubscriber, so
# nothing here relies on the subscriber being attached. The examples call the subscriber's own methods
# (rescue_from_callback, redirect_to) with real ActiveSupport::Notifications events, and the request examples
# forward the real "rescue_from_callback.action_controller" event of a real request into the subscriber.
RSpec.describe "CannLabs log message redaction" do
  # 20 hex: routes constrained to 32 hex (/associate/:token) do not match it, so it is a router miss there.
  secret = "cafe0123deadbeef4567"
  secret32 = "cafe0123deadbeef4567cafe0123dead"
  filtered = "[FILTERED]"

  let(:subscriber) { ActionController::LogSubscriber.new }
  let(:io) { StringIO.new }

  around do |example|
    previous = ActionController::Base.logger
    ActionController::Base.logger = ActiveSupport::Logger.new(io)
    example.run
  ensure
    ActionController::Base.logger = previous
  end

  def event(name, payload)
    ActiveSupport::Notifications::Event.new(
      "#{name}.action_controller",
      Time.now,
      Time.now,
      SecureRandom.hex(8),
      payload,
    )
  end

  # An exception with a real backtrace.
  def raised(exception_class, message)
    raise exception_class, message
  rescue exception_class => e
    e
  end

  def first_frame(exception)
    exception.backtrace.first.delete_prefix(Rails.root.to_s).delete_prefix("/")
  end

  def logged_lines
    io.string.lines.map(&:chomp)
  end

  def rescue_line(exception)
    subscriber.rescue_from_callback(event("rescue_from_callback", exception: exception))
    logged_lines.find { |line| line.start_with?("rescue_from handled") }
  end

  def redirect_line(location)
    subscriber.redirect_to(event("redirect_to", location: location, status: 302, request: nil))
    logged_lines.find { |line| line.start_with?("Redirected to") }
  end

  # The full Rack stack, for requests the integration session cannot build (an invalid percent-encoding is not a
  # valid URI).
  def call_app(verb, path, query: nil)
    env = Rack::MockRequest.env_for("/", method: verb.to_s.upcase)
    env["PATH_INFO"] = path
    env["QUERY_STRING"] = query.to_s
    env["REQUEST_URI"] = query ? "#{path}?#{query}" : path
    env["HTTP_HOST"] = "test.localhost"
    env["HTTP_ACCEPT"] = "text/html"
    env["REMOTE_ADDR"] = "127.0.0.1"
    status, _headers, body = Rails.application.call(env)
    body.each { |_| }
    body.close if body.respond_to?(:close)
    status
  end

  # Runs the block and forwards every real rescue_from_callback event into the subscriber under test.
  def forwarding_rescue_events
    events = []
    listener =
      lambda do |ev|
        events << ev
        subscriber.rescue_from_callback(ev)
      end
    ActiveSupport::Notifications.subscribed(listener, "rescue_from_callback.action_controller") do
      yield
    end
    events
  end

  describe "extension point" do
    it "patches the ActionController::LogSubscriber methods it relies on" do
      %i[rescue_from_callback redirect_to].each do |name|
        expect(ActionController::LogSubscriber.public_method_defined?(name)).to eq(true)
        expect(ActionController::LogSubscriber.instance_method(name).arity).to eq(1)
      end

      ancestors = ActionController::LogSubscriber.ancestors
      expect(ancestors).to include(CannlabsLogMessageRedaction::Subscriber)
      expect(ancestors.index(CannlabsLogMessageRedaction::Subscriber)).to be <
        ancestors.index(ActionController::LogSubscriber)
    end

    # If this fails, Rails changed what it logs: review whether the extension is still needed.
    it "is still needed: the stock subscriber prints the raw path and location" do
      stock_rescue =
        ActionController::LogSubscriber.instance_method(:rescue_from_callback).super_method
      stock_redirect = ActionController::LogSubscriber.instance_method(:redirect_to).super_method
      exception =
        raised(ActionController::RoutingError, %(No route matches [GET] "/associate/#{secret}"))

      stock_rescue.bind(subscriber).call(event("rescue_from_callback", exception: exception))
      stock_redirect.bind(subscriber).call(
        event("redirect_to", location: "/associate/#{secret32}", status: 302, request: nil),
      )

      expect(io.string).to include(secret)
      expect(io.string).to include("Redirected to /associate/#{secret32}")
    end
  end

  describe "router misses (rescue_from handled)" do
    credential_paths =
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

    credential_paths.each do |prefix|
      it "redacts #{prefix}:secret and keeps the class, verb and path structure" do
        message = %(No route matches [GET] "#{prefix}#{secret}")
        exception = raised(ActionController::RoutingError, message)

        expect(rescue_line(exception)).to eq(
          "rescue_from handled ActionController::RoutingError " \
            "(No route matches [GET] \"#{prefix}#{filtered}\") - #{first_frame(exception)}",
        )
        expect(io.string).not_to include(secret)
        expect(exception.message).to eq(message)
      end
    end

    it "redacts a message without a verb (recognize_path)" do
      expect(
        CannlabsLogMessageRedaction.message(%(No route matches "/u/password-reset/#{secret}")),
      ).to eq(%(No route matches "/u/password-reset/#{filtered}"))
    end

    it "keeps a format suffix" do
      expect(
        CannlabsLogMessageRedaction.message(
          %(No route matches [GET] "/users/password-reset/#{secret}.json"),
        ),
      ).to eq(%(No route matches [GET] "/users/password-reset/#{filtered}.json"))
    end

    it "redacts the realistic normalized variants" do
      {
        "/u//password-reset//#{secret}" => "/u/password-reset/#{filtered}",
        "/u/password%2Dreset/#{secret}" => "/u/password-reset/#{filtered}",
        "/users/%61ctivate-account/#{secret}" => "/users/activate-account/#{filtered}",
        "/u/password-reset/#{secret}/" => "/u/password-reset/#{filtered}/",
      }.each do |path, expected|
        logged = CannlabsLogMessageRedaction.message(%(No route matches [GET] "#{path}"))

        expect(logged).to eq(%(No route matches [GET] "#{expected}"))
        expect(logged).not_to include(secret)
      end
    end

    it "leaves everything else exactly as it is" do
      [
        %(No route matches [GET] "/t/some-topic/12"),
        %(No route matches [POST] "/u/password-reset"),
        %(No route matches {action: "show", controller: "topics"}),
        "Discourse::NotFound",
        "",
      ].each { |message| expect(CannlabsLogMessageRedaction.message(message)).to equal(message) }
    end

    it "logs a plain exception exactly as Rails does" do
      exception = raised(Discourse::NotFound, "Discourse::NotFound")

      expect(rescue_line(exception)).to eq(
        "rescue_from handled Discourse::NotFound (Discourse::NotFound) - #{first_frame(exception)}",
      )
    end

    it "does not raise on invalid bytes, and still redacts" do
      message = "No route matches [GET] \"/u/password-reset/\xFF#{secret}\"".b

      expect(CannlabsLogMessageRedaction.message(message)).to eq(
        %(No route matches [GET] "/u/password-reset/#{filtered}"),
      )
    end
  end

  describe "invalid %-encoding" do
    it "redacts only the fragment, including parentheses and newlines" do
      [
        "invalid %-encoding (%zz#{secret})",
        "invalid %-encoding (%zz#{secret}))(x)",
        "invalid %-encoding (%zz#{secret}))(x",
        "invalid %-encoding (%zz(#{secret})",
        "invalid %-encoding (%zz\n#{secret})",
      ].each do |message|
        redacted = CannlabsLogMessageRedaction.message(message)

        expect(redacted).to eq("invalid %-encoding ([FILTERED])")
        expect(redacted).not_to include(secret)
      end
    end

    it "keeps what surrounds the fragment" do
      expect(
        CannlabsLogMessageRedaction.message(
          "Invalid query parameters: invalid %-encoding (%zz#{secret})",
        ),
      ).to eq("Invalid query parameters: invalid %-encoding ([FILTERED])")
    end

    it "keeps the closing parenthesis of the logged message and the backtrace frame" do
      exception = raised(ArgumentError, "invalid %-encoding (%zz#{secret})")

      expect(rescue_line(exception)).to eq(
        "rescue_from handled ArgumentError (invalid %-encoding ([FILTERED])) - #{first_frame(exception)}",
      )
      expect(exception.message).to eq("invalid %-encoding (%zz#{secret})")
    end

    it "is what a real malformed query logs, and the request is unchanged" do
      status = nil
      events =
        forwarding_rescue_events do
          status = call_app(:get, "/session/csrf.json", query: "code=%zz#{secret}(x)&y=1")
        end

      expect(status).to eq(400)
      expect(io.string).to include("invalid %-encoding ([FILTERED])")
      expect(io.string).not_to include(secret)
      expect(events.map { |ev| ev.payload[:exception].message }).to all(include(secret))
    end
  end

  describe "real unroutable and mismatched requests", type: :request do
    {
      "an unroutable credential-looking path" => [:get, "/associate/#{secret}"],
      "the wrong method on a credential route" => [:post, "/u/password-reset/#{secret}"],
      "GET on a PUT-only credential route" => [:get, "/invites/show/#{secret}"],
      "a percent-encoded literal segment" => [:get, "/u/password%2Dreset/#{secret}"],
      "an unknown format suffix" => [:get, "/u/password-reset/#{secret}.xyz"],
    }.each do |label, (verb, path)|
      it "logs no raw secret for #{label}, and the response and exception are unchanged" do
        events = forwarding_rescue_events { public_send(verb, path) }
        routing = events.map { |ev| ev.payload[:exception] }.grep(ActionController::RoutingError)

        expect(response.status).to eq(404)
        expect(routing.size).to eq(1)
        expect(routing.first.message).to include(secret)
        expect(io.string).not_to include(secret)
        expect(io.string).to include("ActionController::RoutingError (No route matches")
        expect(io.string).to include("[#{verb.to_s.upcase}]")
        expect(io.string).to include(filtered)
      end
    end

    it "logs nothing about a routable credential path" do
      events = forwarding_rescue_events { get "/u/password-reset/#{secret}" }

      expect(response.status).to eq(200)
      expect(
        events.map { |ev| ev.payload[:exception] }.grep(ActionController::RoutingError),
      ).to be_empty
      expect(io.string).not_to include(secret)
    end

    it "logs no raw secret when a method mismatch is rescued by Discourse's own handler" do
      forwarding_rescue_events { put "/invites/#{secret}" }

      expect(io.string).not_to include(secret)
    end
  end

  describe "redirect_to" do
    {
      "a path" => ["/associate/#{secret32}", "/associate/#{filtered}"],
      "an absolute URL" => [
        "https://community.example/associate/#{secret32}",
        "https://community.example/associate/#{filtered}",
      ],
      "a path with the Task 36 query keys" => [
        "/associate/#{secret32}?token=#{secret}&country_code=AU",
        "/associate/#{filtered}?token=#{filtered}&country_code=AU",
      ],
      "a fragment" => ["/associate/#{secret32}#top", "/associate/#{filtered}#top"],
      "a doubled slash" => ["/u//password-reset//#{secret}", "/u/password-reset/#{filtered}"],
    }.each do |label, (location, expected)|
      it "logs #{label} without the secret, and leaves the event payload alone" do
        ev = event("redirect_to", location: location, status: 302, request: nil)
        subscriber.redirect_to(ev)

        expect(logged_lines.first).to eq("Redirected to #{expected}")
        expect(io.string).not_to include(secret)
        expect(ev.payload[:location]).to eq(location)
      end
    end

    it "logs a location without a credential exactly as Rails does" do
      %w[/latest?page=2 https://community.example/t/some-topic/12 /].each do |location|
        io.truncate(0)
        io.rewind

        expect(redirect_line(location)).to eq("Redirected to #{location}")
      end
    end
  end
end
