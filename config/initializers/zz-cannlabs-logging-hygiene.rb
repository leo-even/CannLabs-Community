# frozen_string_literal: true

# CannLabs Community: keep security-sensitive values out of logs.
#
# Sorts after the upstream initializers so it extends, never replaces, their configuration.

# Exact-name parameter filters, in every environment. They apply to the request line
# (`filtered_path`) and to the controller parameter log. Anchored so that names merely
# containing a word (country_code, invite_code) stay visible.
Rails.application.config.filter_parameters |=
  %w[
    code
    state
    token
    access_token
    refresh_token
    id_token
    client_secret
    authenticity_token
  ].map { |name| /\A#{name}\z/ }

# Development: ActiveRecord SQL logging is off by default. With prepared_statements
# disabled, SQL lines carry literal values (OAuth tokens, password hashes, TOTP secrets)
# that bind filtering cannot redact. This is the same effect as upstream's
# RAILS_DISABLE_ACTIVERECORD_LOGS=1, applied to every process (web, Sidekiq, runner, rake).
#
# CANNLABS_ENABLE_ACTIVERECORD_LOGS=1 restores SQL logging for a single process when
# debugging. Those lines can contain sensitive values.
if Rails.env.development? && ENV["CANNLABS_ENABLE_ACTIVERECORD_LOGS"] != "1"
  ActiveSupport.on_load(:active_record) { self.logger = nil }
end
