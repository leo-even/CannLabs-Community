# frozen_string_literal: true

# CannLabs Community: keep one-time credentials that travel in URL *paths* out of Rails request logs.
#
# zz-cannlabs-logging-hygiene.rb filters the query string and the parameter log through
# `config.filter_parameters`. That cannot reach a path segment: /u/password-reset/:token is logged
# verbatim by `Rails::Rack::Logger` ("Started GET ...") and by the controller instrumentation
# payload, and both read `ActionDispatch::Request#filtered_path`.
#
# This initializer extends that one public method, and registers one parameter filter. Core, the
# routes and the existing hygiene initializer are untouched.
module CannlabsPathSecretRedaction
  FILTERED = "[FILTERED]"

  # The secret is the first segment after the prefix, up to the next "/" or ".", so a format
  # suffix such as ".json" survives. The prefixes are the credential-bearing core routes in
  # config/routes.rb (the spec fails when a new core :token route appears). They are
  # root-relative: subfolder installs (DISCOURSE_RELATIVE_URL_ROOT) are not covered.
  RULES = [
    %r{\A(/(?:u|users)/(?:password-reset|confirm-email-token|activate-account|confirm-old-email|confirm-new-email|confirm-admin)/)[^/.]+},
    %r{\A(/session/(?:email-login|otp)/)[^/.]+},
    %r{\A(/associate/)[^/.]+},
    %r{\A(/invites/(?:show/)?)[^/.]+},
    %r{\A(/email/unsubscribe/)[^/.]+},
  ].freeze

  UNRESERVED = /\A[A-Za-z0-9_~-]\z/

  # The app server sees the path as the client sent it, while the router treats repeated "/" and
  # percent-encoded unreserved characters as the same route. Match on that equivalent form.
  # "." stays encoded: it separates the format suffix, and keeping it encoded cannot split a
  # secret in two.
  def self.normalize(path)
    path
      .to_s
      .dup
      .force_encoding(Encoding::UTF_8)
      .scrub
      .gsub(/%\h\h/) { |escape| (char = escape[1, 2].hex.chr).match?(UNRESERVED) ? char : escape }
      .squeeze("/")
  end

  # The redacted path, or nil when the path carries no credential.
  def self.redact(path)
    normalized = normalize(path)
    rule = RULES.find { |candidate| normalized.match?(candidate) }
    rule && normalized.sub(rule, "\\1#{FILTERED}")
  end

  module RequestExtension
    def filtered_path
      @cannlabs_filtered_path ||=
        begin
          stock = super
          path, separator, query = stock.dup.force_encoding(Encoding::UTF_8).scrub.partition("?")
          redacted = CannlabsPathSecretRedaction.redact(path)
          redacted ? "#{redacted}#{separator}#{query}" : stock
        end
    end
  end

  # These path parameters are credentials only on one controller (an invite key, an email
  # unsubscribe key). Matching on the controller keeps ordinary resource ids, such as topic ids,
  # visible. `original_params` carries the request's controller and action.
  CREDENTIAL_PARAMETERS = { "invites" => "id", "email" => "key" }.freeze

  PARAMETER_FILTER =
    lambda do |key, value, original_params|
      if value.is_a?(String) && original_params.is_a?(Hash) &&
           CREDENTIAL_PARAMETERS[original_params["controller"]] == key
        value.replace(FILTERED)
      end
    end
end

ActionDispatch::Request.prepend(CannlabsPathSecretRedaction::RequestExtension)
Rails.application.config.filter_parameters |= [CannlabsPathSecretRedaction::PARAMETER_FILTER]
