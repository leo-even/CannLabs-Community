# frozen_string_literal: true

# CannLabs Community: keep request secrets out of the request environment Logster stores.
#
# When a warning or error is logged while a request is being served, Logster attaches that
# request's environment to the stored message (visible to admins at /logs). It copies
# REQUEST_URI and HTTP_REFERER verbatim and the request params with only "password" keys
# redacted. It does not consult Rails' filter_parameters, so OAuth `code` / `state` and the
# tokens in credential paths would be persisted.
#
# This prepends one module on Logster::Message.populate_env_helper, the gem-internal method behind
# the public Logster::Message.populate_from_env (which upstream Discourse calls as well), and
# re-expresses three fields through Rails' own filters:
#
#   REQUEST_URI   the request's filtered_path (query filters from zz-cannlabs-logging-hygiene.rb,
#                 path secrets from zz-cannlabs-path-secret-redaction.rb)
#   params        the request's parameter filter
#   HTTP_REFERER  its origin
#
# Everything else Logster stores is left alone.
#
# Params that cannot be parsed
#
# Logster reads the params by parsing the request again (Rack::Request#params). A malformed body or
# query ("password=%zz...") raises there, and the exception message repeats the offending fragment.
# Logster::Logger#add_with_opts rescues everything and prints "Failed to report error: #{e} ...", so
# the fragment reached the container's stderr (Docker logs), and the event was never stored.
#
# So the parse is attempted once up front, and ONLY that call is rescued. When it fails, the env is
# built without params: the same allowed fields Logster would store, the sanitized REQUEST_URI and
# Referer, and a marker whose value is the exception class name. The parse error's message is
# dropped, and params are left out rather than replaced by an empty hash. Rack memoizes a successful
# parse in the request env, so a valid request is not parsed twice. Nothing else is rescued here: a
# failure in default_env, in the scrub below, or later in the store still reaches Logster's own
# handling unchanged. The exceptions Rack can raise here share no base class, which is why the
# rescue is scoped to the call and not to a list of classes.
#
# This is a gem-internal API. If a Logster upgrade removes it, boot fails here, loudly, instead of
# silently storing secrets again. spec/initializers/cannlabs_logster_secret_redaction_spec.rb
# fails for the same reason.
unless Logster::Message.respond_to?(:populate_env_helper)
  raise "CannLabs Logster secret redaction: Logster::Message.populate_env_helper is missing " \
          "(Logster #{Logster::VERSION}). Review zz-cannlabs-logster-secret-redaction.rb " \
          "before upgrading Logster."
end

module CannlabsLogsterSecretRedaction
  ORIGIN = %r{\Ahttps?://[^/?#\s]+}i

  # Stored instead of `params` when the request's params could not be parsed. The value is the
  # class name of the parse failure and nothing else.
  PARAMS_UNAVAILABLE = "params_unavailable_due_to_parse_error"

  def populate_env_helper(env)
    failure = request_params_failure(env)
    scrubbed = failure ? env_without_params(env, failure) : super

    # Logster returns non-request environments (jobs, custom hashes) unchanged. So do we.
    return scrubbed unless env.is_a?(Hash) && env.include?("rack.input") && scrubbed.is_a?(Hash)

    # The filter is passed explicitly so the result does not depend on how the env was built.
    request =
      ActionDispatch::Request.new(
        env.merge("action_dispatch.parameter_filter" => Rails.application.config.filter_parameters),
      )

    scrubbed["REQUEST_URI"] = request.filtered_path if scrubbed["REQUEST_URI"]
    scrubbed["params"] = request.parameter_filter.filter(scrubbed["params"]) if scrubbed["params"]
    if scrubbed["HTTP_REFERER"]
      scrubbed["HTTP_REFERER"] = scrubbed["HTTP_REFERER"].to_s.scrub[ORIGIN] || "-"
    end

    scrubbed
  end

  private

  # The failure of the params parse Logster is about to make, or nil. This is the only code in
  # this file inside a rescue, and it is the same call Logster makes.
  def request_params_failure(env)
    if !env.is_a?(Hash) || !env.include?("rack.input") || env.key?(Logster::Message::LOGSTER_ENV)
      return
    end

    begin
      Rack::Request.new(env).params
      nil
    rescue StandardError => failure
      failure
    end
  end

  # What Logster would store for this request, minus the params.
  def env_without_params(env, failure)
    unavailable = default_env
    Logster::Message::ALLOWED_ENV.each { |key| unavailable[key] = env[key] if env[key] }
    unavailable[PARAMS_UNAVAILABLE] = failure.class.to_s

    # Logster memoizes its result in the env. A frozen env (not something a Rack server hands out)
    # cannot hold it, and has no parsed params either.
    env[Logster::Message::LOGSTER_ENV] = unavailable unless env.frozen?
    unavailable
  end
end

Logster::Message.singleton_class.prepend(CannlabsLogsterSecretRedaction)
