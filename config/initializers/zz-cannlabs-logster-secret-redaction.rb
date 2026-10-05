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

  def populate_env_helper(env)
    scrubbed = super

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
end

Logster::Message.singleton_class.prepend(CannlabsLogsterSecretRedaction)
