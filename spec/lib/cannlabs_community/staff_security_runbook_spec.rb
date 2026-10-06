# frozen_string_literal: true

# Guards the production staff security runbook (ops/discourse/STAFF_SECURITY.md, DEC-044): the first-admin
# procedure keeps its safe order, never instructs a forbidden bootstrap route in a command, carries no
# secret-shaped value and ships a read-only audit. The developer-emails variable in deployment artifacts
# is already guarded by production_secrets_contract_spec.rb.
RSpec.describe "Production staff security runbook" do # rubocop:disable RSpec/DescribeClass
  let(:runbook) { File.read(Rails.root.join("ops/discourse/STAFF_SECURITY.md")) }
  let(:blocks) { runbook.scan(/^```\w*\n(.*?)^```/m).flatten }
  let(:commands) { blocks.join("\n") }
  let(:audit_ruby) do
    body = blocks.find { |block| block.include?("STAFF_SECURITY_AUDIT=") }
    body.to_s[/<<'RUBY'\n(.*)^RUBY$/m, 1].to_s
  end

  def section(title)
    runbook[/^## \d+\. #{Regexp.escape(title)}\n.*?(?=^## \d+\. |\z)/m] ||
      raise("STAFF_SECURITY.md has no section titled #{title.inspect}")
  end

  it "keeps the first admin, its enrollment and the second admin before turning enforcement on" do
    titles = [
      "First admin (create)",
      "First admin: log in, enroll 2FA, store recovery codes",
      "Second admin",
      "Turn enforcement on",
    ]

    positions = titles.map { |title| runbook.index(section(title)) }

    expect(positions).to eq(positions.sort)
    expect(section("Turn enforcement on")).to include("staff_without_second_factor=0").and include(
            "admins_human=2",
          )
  end

  it "never instructs a forbidden bootstrap route or a standing bypass in a command" do
    forbidden = {
      "the developer-emails variable" => /DISCOURSE_DEVELOPER_EMAILS/,
      "/finish-installation" => /finish-installation/,
      "rake admin:invite" => /admin:invite/,
      "a random first-admin password" => /RANDOM_PASSWORD/,
      "a password set in a script" => /\.password\s*=/,
      "enforcement turned off" => /enforce_second_factor\s*=\s*["']?no/,
    }

    offenders = forbidden.select { |_label, pattern| commands.match?(pattern) }.keys

    expect(offenders).to be_empty, "command blocks must not instruct: #{offenders.join(", ")}"
  end

  it "contains no secret-shaped value and no email address" do
    secret_shape =
      /\b[0-9a-f]{32,}\b|\b[A-Z2-7]{26,}\b|-----BEGIN [A-Z ]*PRIVATE KEY-----|\bAKIA[0-9A-Z]{16}\b/
    emails = runbook.scan(/[\w.+-]+@[\w-]+(?:\.[\w-]+)+/)

    expect(runbook).not_to match(secret_shape)
    expect(emails).to be_empty,
    "the runbook must use placeholders, not addresses: #{emails.join(", ")}"
  end

  it "ships an audit that parses, is read-only and prints no second-factor secret" do
    expect(audit_ruby).to include("STAFF_SECURITY_AUDIT=")
    expect { RubyVM::InstructionSequence.compile(audit_ruby) }.not_to raise_error

    writes = /\.(destroy_all|destroy|update!?|update_all|save!?|create!?|delete_all|delete)\b/
    secrets = /\.data\b|code_hash|key_hash|salt|password|second_factor_token|unhashed/
    assignment = /\bSiteSetting\.\w+\s*=[^=]/

    expect(audit_ruby).not_to match(writes)
    expect(audit_ruby).not_to match(assignment)
    expect(audit_ruby).not_to match(secrets)
  end
end
