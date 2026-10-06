# frozen_string_literal: true

# Guards the tracked production deployment definition (ops/discourse/cannlabs-production.yml,
# ops/discourse/PRODUCTION.md, DEC-046, DEC-047). Secret values, private keys and the developer-emails
# variable in every ops/discourse artifact are already guarded by production_secrets_contract_spec.rb, and the
# plugin pin and the nginx redaction rules by prodlike_deployment_parity_spec.rb.
RSpec.describe "Production deployment definition" do # rubocop:disable RSpec/DescribeClass
  prodlike_sha = "89222f0af613aefacbbb26bac8c5f33c895aa7243eb70fca0eb4e7c64188065f"
  launcher_pin = "8d705a91866c320592ce851f30895ddb4c3e85fe"
  end_marker = %(  - exec: echo "End of custom commands"\n)

  let(:ops_dir) { Rails.root.join("ops/discourse") }
  let(:text) { File.read(ops_dir.join("cannlabs-production.yml")) }
  let(:definition) { YAML.safe_load(text) }
  let(:prodlike_text) { File.read(ops_dir.join("cannlabs-prodlike.yml")) }
  let(:manifest) { CannlabsCommunity::Bootstrap.manifest }
  let(:runbook) { File.read(ops_dir.join("PRODUCTION.md")) }
  let(:code) { text.lines.reject { |line| line.lstrip.start_with?("#") }.join }
  let(:run_steps) { ->(content) { content[content.index("\nrun:\n")..] } }
  let(:pin) { definition.dig("params", "version") }

  it "serves exactly one canonical hostname and one redirect-only alias" do
    env = definition["env"]

    expect(env["DISCOURSE_HOSTNAME"]).to eq("community.cannlabs.com.br")
    expect(env["DISCOURSE_HOSTNAME_ALIASES"]).to eq("comunidade.cannlabs.com.br")
    expect(env.keys.grep(/HOSTNAME|APP_HOST/)).to contain_exactly(
      "DISCOURSE_HOSTNAME",
      "DISCOURSE_HOSTNAME_ALIASES",
    )
    expect(definition["templates"]).to include(
      "templates/web.ssl.template.yml",
      "templates/web.letsencrypt.ssl.template.yml",
    )
    expect(code.scan("comunidade.cannlabs.com.br").size).to eq(1)
    expect(code).not_to match(/server_name|proxy_pass|listen /)
  end

  it "has no Cloudflare, IPv6, Mailpit or custom network element" do
    expect(definition["templates"].grep(/cloudflare|fastly|ipv6|china|onion|socketed/)).to be_empty
    expect(code).not_to match(/cloudflare|cf-connecting|\[::\]|ipv6|mailpit/i)
    expect(definition["docker_args"]).not_to include("--network")
  end

  it "publishes only IPv4 TCP 80 and 443" do
    expect(definition["expose"]).to contain_exactly("0.0.0.0:80:80", "0.0.0.0:443:443")
  end

  it "delivers secrets only through the root-only host file" do
    args = definition["docker_args"]

    expect(args.scan("--env-file")).to eq(["--env-file"])
    expect(args).to include("--env-file /etc/cannlabs-community/production.env")
    expect(args).not_to match(/(\A|\s)-e\s/)
    expect(File.read(ops_dir.join("SECRETS.md"))).to include(
      "/etc/cannlabs-community/production.env",
    )
  end

  it "keeps the validated prodlike definition byte-frozen" do
    expect(Digest::SHA256.hexdigest(File.binread(ops_dir.join("cannlabs-prodlike.yml")))).to eq(
      prodlike_sha,
    )
  end

  it "starts with the validated prodlike hardening and keeps its own logging block guarded" do
    validated = run_steps.call(prodlike_text).delete_suffix(end_marker)
    production = run_steps.call(text)
    replace =
      definition["run"]
        .filter_map { |step| step["replace"] if step.is_a?(Hash) }
        .find do |entry|
          entry["filename"] == "/etc/nginx/nginx.conf" && entry["from"].start_with?("access_log")
        end

    expect(production).to start_with(validated)
    expect(replace).to be_present
    expect(replace["to"]).to include("log_format cannlabs_http_safe")
    expect(replace["to"]).to include("access_log /var/log/nginx/access.log cannlabs_http_safe;")
    expect(replace["to"]).not_to match(
      /\$request(?!_method)|\$request_uri|\$uri|\$args|\$query_string|\$http_referer/,
    )
    expect(production.delete_prefix(validated).scan("CannLabs guard:").size).to be >= 4
  end

  it "sizes the starting profile from the pinned official formula" do
    memory_gb = 8
    cores = 2

    expect(definition.dig("params", "db_shared_buffers")).to eq("#{[memory_gb * 256, 4096].min}MB")
    expect(definition.dig("env", "UNICORN_WORKERS")).to eq([[2 * cores, 1].max, 8].min)
  end

  it "pins the application at a full commit that is an ancestor of HEAD and owns the robots setting" do
    git = ["git", "-C", Rails.root.to_s]
    present = system(*git, "cat-file", "-e", "#{pin}^{commit}", out: File::NULL, err: File::NULL)
    skip "the application pin is not in this checkout's history" if !present

    expect(pin).to match(/\A\h{40}\z/)
    expect(system(*git, "merge-base", "--is-ancestor", pin, "HEAD")).to eq(true)

    pinned_manifest =
      IO.popen([*git, "show", "#{pin}:config/cannlabs_community/bootstrap.yml"], &:read)
    expect(
      YAML.safe_load(pinned_manifest).dig("profile_settings", "allow_index_in_robots_txt"),
    ).to eq("production" => false)
  end

  it "has the bootstrap own search-engine indexing off in the production profile only" do
    expect(manifest.dig("profile_settings", "allow_index_in_robots_txt")).to eq(
      "production" => false,
    )
    expect(manifest["settings"]).not_to have_key("allow_index_in_robots_txt")
  end

  it "keeps the runbook labels, the IPv6 and DNS contracts and the secret-material class" do
    [
      "PRODUCTION — NOT READY",
      "PUBLIC ACME ISSUANCE — NOT YET VALIDATED",
      "PRODUCTION STARTING SIZE — HYPOTHESIS",
      "2 vCPU / 8 GB STARTING-SIZE PROFILE",
      "IPv6 V1 — DO NOT ENABLE YET",
      "REAL-HOST ACCEPTANCE REQUIRED",
      "HOST/DEPLOYMENT SECRET MATERIAL",
      "No `AAAA` for either name",
    ].each { |label| expect(runbook).to include(label) }
    expect(File.read(ops_dir.join("SECRETS.md"))).to include("HOST/DEPLOYMENT SECRET MATERIAL")
  end

  it "cites no commit that is not a known pin" do
    known = [pin, launcher_pin, manifest["theme"]["revision"], manifest["plugin"]["revision"]]

    expect(runbook.scan(/\b\h{40}\b/).uniq - known).to be_empty
  end

  it "opens public 443 last, after the staff, bootstrap, gate and SMTP steps" do
    section = runbook[/^## 12\. .*?(?=^## 13\. )/m] || raise("PRODUCTION.md has no section 12")
    steps = section.lines.grep(/\A\d+\. /)
    markers = [
      "443 is closed",
      "production.env",
      "A records",
      "TCP 80 only",
      "./launcher rebuild",
      "admin:create",
      "first operator",
      "first administrator",
      "second administrator",
      "enforce_second_factor",
      "bootstrap",
      "Restart",
      "gate",
      "real-host",
      "SMTP",
      "audit",
      "Open TCP 443 to the world",
      "Re-run the gate",
    ]

    expect(steps.size).to eq(markers.size)
    steps
      .zip(markers)
      .each_with_index do |(step, marker), index|
        expect(step).to start_with("#{index + 1}. ")
        expect(step).to include(marker)
      end
    expect(steps[0..15].grep(/Open TCP 443/)).to be_empty
    expect(runbook).to include(
      "--base-url https://community.cannlabs.com.br --canonical community.cannlabs.com.br",
    )
  end
end
