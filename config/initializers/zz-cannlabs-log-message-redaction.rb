# frozen_string_literal: true

# CannLabs Community: keep request-derived secrets out of two Rails request log lines.
#
# zz-cannlabs-path-secret-redaction.rb covers what `ActionDispatch::Request#filtered_path` prints.
# `ActionController::LogSubscriber` prints two more lines that carry request material verbatim:
#
#   rescue_from handled <class> (<exception.message>) - <backtrace frame>
#     The message of a routing error is built from the raw PATH_INFO ("No route matches [GET]
#     \"/associate/<secret>\""), and a malformed query value is echoed in
#     "invalid %-encoding (<fragment>)".
#
#   Redirected to <location>
#     The OAuth reconnect flow redirects to /associate/<one-time secret>.
#
# This prepends one module on that subscriber and changes only what is logged. The exception object, its
# message and the redirect target are never modified, so HTTP behavior and every other consumer of the
# exception are unchanged. The class, the verb, the path structure and the backtrace frame stay in the line.
#
# `ActionController::LogSubscriber` is a `:nodoc:` Rails class. If an upgrade removes or reshapes the two
# methods, boot fails here, loudly, instead of silently logging secrets again, and
# spec/initializers/cannlabs_log_message_redaction_spec.rb fails for the same reason.
#
# Specs run with Lograge enabled (spec/rails_helper.rb), which unsubscribes this subscriber, so the spec calls
# the subscriber directly. The production-like instance does not load Lograge.
module CannlabsLogMessageRedaction
  FILTERED = "[FILTERED]"

  # Router misses: `No route matches [VERB] "<PATH_INFO.inspect>"` (the verb is absent when raised by
  # `recognize_path`). A hash after "No route matches" (url generation) does not match.
  NO_ROUTE = /(No route matches (?:\[[A-Z]+\] )?)"((?:[^"\\]|\\.)*)"/

  # Ruby's malformed percent-encoding message echoes the offending fragment: "invalid %-encoding (<fragment>)".
  # Applied to the exception message, never to the formatted log line, so everything after the opening
  # parenthesis belongs to the message. It fails closed: the fragment is dropped whatever it contains and
  # whether or not the message still ends with ")".
  BAD_ENCODING = /invalid %-encoding \(.*\z/m

  LOCATION = %r{\A((?:[a-z][a-z0-9+.-]*:)?//[^/?#]*)?([^?#]*)(?:\?([^#]*))?}i

  # The text that would be logged for an exception message.
  def self.message(text)
    original = text.to_s
    scrubbed = original.scrub
    redacted =
      scrubbed
        .gsub(NO_ROUTE) do
          match = Regexp.last_match
          path = CannlabsPathSecretRedaction.redact(match[2])
          path ? %(#{match[1]}"#{path}") : match[0]
        end
        .sub(BAD_ENCODING, "invalid %-encoding (#{FILTERED})")
    redacted == scrubbed ? original : redacted
  end

  # The text that would be logged for a redirect location: the credential path is redacted and the query
  # string goes through the app's filter_parameters, both through the accepted filtered_path. The origin and
  # the fragment are kept.
  def self.location(location)
    original = location.to_s
    scrubbed = original.scrub
    match = LOCATION.match(scrubbed)
    return original unless match

    request =
      ActionDispatch::Request.new(
        "SCRIPT_NAME" => "",
        "PATH_INFO" => match[2],
        "QUERY_STRING" => match[3].to_s,
        "action_dispatch.parameter_filter" => Rails.application.config.filter_parameters,
      )
    redacted = "#{match[1]}#{request.filtered_path}#{scrubbed[match.end(0)..]}"
    redacted == scrubbed ? original : redacted
  end

  # What the subscriber sees instead of the exception: the same class and backtrace, a redacted message.
  class LoggedException < SimpleDelegator
    def initialize(exception, message)
      super(exception)
      @message = message
    end

    def message = @message

    def class = __getobj__.class
  end

  # What the subscriber sees instead of the event: the same event with a replaced payload.
  class LoggedEvent < SimpleDelegator
    def initialize(event, payload)
      super(event)
      @payload = payload
    end

    def payload = @payload
  end

  module Subscriber
    def rescue_from_callback(event)
      exception = event.payload[:exception]
      message = exception.message
      redacted = CannlabsLogMessageRedaction.message(message)
      return super if redacted == message

      payload = event.payload.merge(exception: LoggedException.new(exception, redacted))
      super(LoggedEvent.new(event, payload))
    end

    def redirect_to(event)
      location = event.payload[:location]
      redacted = CannlabsLogMessageRedaction.location(location)
      return super if redacted == location.to_s

      super(LoggedEvent.new(event, event.payload.merge(location: redacted)))
    end
  end
end

# ActionController::LogSubscriber is not loaded while config/initializers run (only Lograge loads it early, which
# is why the specs would not notice), and the path rules live in zz-cannlabs-path-secret-redaction.rb, which sorts
# after this file. So everything that touches either waits until every initializer has run. A failure here still
# stops boot.
Rails.application.config.after_initialize do
  if !defined?(CannlabsPathSecretRedaction) || !CannlabsPathSecretRedaction.respond_to?(:redact)
    raise "CannLabs log message redaction needs CannlabsPathSecretRedaction.redact " \
            "(zz-cannlabs-path-secret-redaction.rb)."
  end

  %i[rescue_from_callback redirect_to].each do |name|
    if !ActionController::LogSubscriber.public_method_defined?(name) ||
         ActionController::LogSubscriber.instance_method(name).arity != 1
      raise "CannLabs log message redaction: ActionController::LogSubscriber##{name}(event) is missing " \
              "(Rails #{Rails.version}). Review zz-cannlabs-log-message-redaction.rb before upgrading Rails."
    end
  end

  ActionController::LogSubscriber.prepend(CannlabsLogMessageRedaction::Subscriber)
end
