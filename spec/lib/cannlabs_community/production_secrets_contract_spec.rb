# frozen_string_literal: true

# Guards the production secrets contract (ops/discourse/SECRETS.md, DEC-042): tracked deployment
# artifacts carry no secret value and never mention DISCOURSE_DEVELOPER_EMAILS. Markdown is
# documentation and is excluded; every other file under ops/discourse/ is a deployment artifact.
RSpec.describe "Production secrets contract" do # rubocop:disable RSpec/DescribeClass
  placeholder = /\A<[A-Z0-9_]+>\z/
  secret_name = /PASSWORD|SECRET|TOKEN|PRIVATE|_PEM\z|API_KEY|ACCESS_KEY|USER_NAME/
  ops_dir = Rails.root.join("ops/discourse")

  let(:artifacts) do
    Dir
      .glob(ops_dir.join("**/*").to_s, File::FNM_DOTMATCH)
      .select { |path| File.file?(path) && File.extname(path) != ".md" }
  end
  let(:example) { ops_dir.join("production.env.example") }

  def entries(path)
    File
      .readlines(path, chomp: true)
      .reject { |line| line.start_with?("#") || line.strip.empty? }
      .map { |line| line.split("=", 2) }
  end

  it "tracks no populated env file" do
    populated = Dir.glob(ops_dir.join("**/*.env").to_s)

    expect(populated).to be_empty,
    "a populated env file must never be tracked: #{populated.map { |path| path.delete_prefix("#{Rails.root.join("")}") }.join(", ")}"
  end

  it "never sets, templates or reserves a placeholder for DISCOURSE_DEVELOPER_EMAILS" do
    offenders = artifacts.select { |path| File.read(path).match?(/developer_emails/i) }

    expect(offenders).to be_empty,
    "DISCOURSE_DEVELOPER_EMAILS is forbidden in production deployment artifacts (SECRETS.md, section 10): " \
      "#{offenders.map { |path| path.delete_prefix("#{Rails.root.join("")}") }.join(", ")}"
  end

  it "contains no private key and no secret_key_base-shaped literal" do
    offenders =
      artifacts.select do |path|
        File.read(path).match?(
          /-----BEGIN [A-Z ]*PRIVATE KEY-----|\b[0-9a-f]{128}\b|\bAKIA[0-9A-Z]{16}\b/,
        )
      end

    expect(offenders).to be_empty,
    "secret-shaped literal in #{offenders.map { |path| path.delete_prefix("#{Rails.root.join("")}") }.join(", ")}"
  end

  it "keeps secret-class names out of the env block of every tracked definition" do
    offenders =
      artifacts
        .select { |path| %w[.yml .yaml].include?(File.extname(path)) }
        .flat_map do |path|
          env = YAML.safe_load_file(path)&.fetch("env", nil)
          next [] unless env.is_a?(Hash)

          env
            .select { |name, value| name.to_s.match?(secret_name) && value.to_s.strip != "" }
            .keys
            .map { |name| "#{File.basename(path)}: #{name}" }
        end

    expect(offenders).to be_empty,
    "secrets belong in the root-only host file, not in a tracked definition: #{offenders.join(", ")}"
  end

  it "uses only <PLACEHOLDER> values in the env example" do
    populated = entries(example).reject { |_name, value| value.to_s.match?(placeholder) }

    expect(populated.map(&:first)).to be_empty,
    "the env example may hold placeholders only: #{populated.map(&:first).join(", ")}"
  end

  it "keeps the env example to documented secret names" do
    documented = %w[
      DISCOURSE_SMTP_USER_NAME
      DISCOURSE_SMTP_PASSWORD
      DISCOURSE_SECRET_KEY_BASE
      DISCOURSE_GOOGLE_OAUTH2_CLIENT_SECRET
      DISCOURSE_S3_ACCESS_KEY_ID
      DISCOURSE_S3_SECRET_ACCESS_KEY
    ]

    expect(entries(example).map(&:first)).to match_array(documented)
  end
end
