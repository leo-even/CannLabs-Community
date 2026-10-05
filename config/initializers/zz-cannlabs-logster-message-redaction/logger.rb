# frozen_string_literal: true

# CannLabs Community: keep request secrets out of the text Logster is asked to record.
#
# zz-cannlabs-logster-secret-redaction.rb covers the request environment Logster attaches to a
# message. The message text itself can carry request material too: a router miss is worded from the
# raw PATH_INFO ("No route matches [GET] \"/associate/<secret>\""), and a malformed percent-encoding
# repeats its fragment ("invalid %-encoding (<fragment>)"). zz-cannlabs-log-message-redaction.rb
# redacts those in Rails' own log lines. Logster is a second consumer of the same text, and when
# anything fails while it records a message (Redis down, the store raising, a subscriber or chained
# logger raising), Logster::Logger#add_with_opts prints
#
#   Failed to report error: #{e} #{severity} #{message} #{progname}
#
# to stderr, so the raw text ends up in the container's Docker log. That includes messages the
# production ignore list would have dropped: counting an ignored message is itself a Redis write.
#
# This prepends one module on Logster::Logger#add_with_opts. It redacts the String `message` and
# `progname` it is given, wraps a block so that the text the block produces is redacted too, and calls
# `super`. Nothing of upstream is reproduced, its rescue is untouched, and the store, the subscribers
# and the chained loggers receive the redacted text and are otherwise driven exactly as before. The
# redacted text is also what gets stored, so one-time credentials are no longer part of what Logster
# groups by either.
#
#   * progname: `Rails.logger.warn("text")` arrives as add_with_opts(WARN, nil, "text") and upstream
#     only later moves progname into message, so both are redacted.
#   * blocks: `logger.error { "text" }` has no message until upstream yields. The block is wrapped,
#     not called, so it is evaluated exactly as often as before (never below the active level, once
#     per consumer that yields) and an exception it raises propagates as before.
#
# What is redacted is limited to shapes known to carry request-derived credentials:
#
#   * "No route matches [VERB] \"<path>\"" and "invalid %-encoding (<fragment>)"
#     (CannlabsLogMessageRedaction.message)
#   * a URL or absolute path in the text that carries a credential path (/u/password-reset/<token>)
#     or a query string. The path secret is replaced and the query goes through the app's
#     filter_parameters (CannlabsLogMessageRedaction.location). A location with nothing to redact is
#     left as it is.
#
# Any other text, including every ordinary log line, comes back as the same String object. This is not
# a generic scrubber: it does not know about values a database or a library echoes into its own
# messages, and it does not touch an Exception passed in place of text.
#
# If redaction itself fails, the text is replaced by a fixed notice. Letting the error out would make a
# log call raise into application code, which Logster never does, and passing the text on would defeat
# the point.
#
# THE FILE IS CALLED logger.rb ON PURPOSE. When no backtrace is passed, Logster records the caller's by
# dropping the leading frames whose file name ends in "/logger.rb". A wrapper in a file with any other
# name puts its own frames (and the stdlib Logger and Logster::Logger#add frames behind them) at the
# front of the stored backtrace of every plain `Rails.logger.warn`. Rails loads nested initializers.
# spec/initializers/cannlabs_logster_message_redaction_spec.rb fails if either stops being true.
#
# This relies on a gem-internal signature. If a Logster upgrade changes it, boot fails here, loudly,
# instead of the wrapper silently dropping an argument.
module CannlabsLogsterMessageRedaction
  SIGNATURE = [%i[req severity], %i[opt message], %i[opt progname], %i[opt opts], %i[block block]]

  WITHHELD = "[CannLabs: log text withheld because its redaction failed]"

  # The rest of a URL or path inside free text, from its first "/" to the next whitespace or quote
  # ("https://host/a?b=c" gives "//host/a?b=c", which CannlabsLogMessageRedaction.location accepts).
  # Linear: each match consumes its whole token, and the pattern needs no lookbehind.
  LOCATION = %r{/[^\s"'<>]+}

  def add_with_opts(severity, message = nil, progname = progname(), opts = nil, &block)
    message = CannlabsLogsterMessageRedaction.redact(message)
    progname = CannlabsLogsterMessageRedaction.redact(progname)
    block = CannlabsLogsterMessageRedaction.lazily(block) if block

    super(severity, message, progname, opts, &block)
  end

  # The text to record. Anything that is not a String is returned as it is.
  def self.redact(text)
    return text unless text.is_a?(String)

    redacted = CannlabsLogMessageRedaction.message(text)
    readable = redacted.valid_encoding? ? redacted : redacted.scrub
    located =
      readable.gsub(LOCATION) do |location|
        carries_credential?(location) ? CannlabsLogMessageRedaction.location(location) : location
      end

    located == readable ? redacted : located
  rescue StandardError
    WITHHELD
  end

  # Redacts what the block returns, when it is asked for. The block itself is not rescued.
  def self.lazily(block)
    proc { |*arguments| redact(block.call(*arguments)) }
  end

  # Cheap test, so that ordinary paths (every backtrace line) never build a request.
  def self.carries_credential?(location)
    location.include?("?") || credential_path.match?(location)
  end

  # CannlabsPathSecretRedaction::RULES without their start-of-path anchor.
  def self.credential_path
    @credential_path ||=
      Regexp.union(
        CannlabsPathSecretRedaction::RULES.map do |rule|
          Regexp.new(rule.source.delete_prefix("\\A"))
        end,
      )
  end
end

if Logster::Logger.instance_method(:add_with_opts).parameters !=
     CannlabsLogsterMessageRedaction::SIGNATURE
  raise "CannLabs Logster message redaction: Logster::Logger#add_with_opts no longer takes " \
          "#{CannlabsLogsterMessageRedaction::SIGNATURE.inspect} (Logster #{Logster::VERSION}). " \
          "Review zz-cannlabs-logster-message-redaction/logger.rb before upgrading Logster."
end

Logster::Logger.prepend(CannlabsLogsterMessageRedaction)

# The redaction rules live in two initializers that are not guaranteed to have loaded before this one.
# They are only called at runtime, so check once every initializer has run.
Rails.application.config.after_initialize do
  if !defined?(CannlabsLogMessageRedaction) ||
       !%i[message location].all? { |name| CannlabsLogMessageRedaction.respond_to?(name) } ||
       !defined?(CannlabsPathSecretRedaction::RULES)
    raise "CannLabs Logster message redaction needs CannlabsLogMessageRedaction.message and .location " \
            "(zz-cannlabs-log-message-redaction.rb) and CannlabsPathSecretRedaction::RULES " \
            "(zz-cannlabs-path-secret-redaction.rb)."
  end
end
