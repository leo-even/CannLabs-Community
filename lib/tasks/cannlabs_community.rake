# frozen_string_literal: true

# Usage:
#   bin/rake cannlabs_community:bootstrap:audit PROFILE=local
#   bin/rake cannlabs_community:bootstrap:apply PROFILE=local
#
# FORMAT=json prints a machine-readable result. The exit status is 0 for PASS,
# 1 for DRIFT, 2 for BLOCKED and 3 for a usage error.

desc "Audit the CannLabs Community product state against the bootstrap manifest (no writes)"
task "cannlabs_community:bootstrap:audit" => :environment do
  exit CannlabsCommunity::Bootstrap.run(profile: ENV["PROFILE"], format: ENV["FORMAT"])
end

desc "Apply the CannLabs Community bootstrap manifest (idempotent)"
task "cannlabs_community:bootstrap:apply" => :environment do
  exit CannlabsCommunity::Bootstrap.run(profile: ENV["PROFILE"], apply: true, format: ENV["FORMAT"])
end
