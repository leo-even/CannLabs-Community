# frozen_string_literal: true

# ops/discourse/cannlabs-prodlike.yml repeats two values that the application also owns. Nothing
# else keeps them in step.
RSpec.describe "Production-like deployment definition parity" do # rubocop:disable RSpec/DescribeClass
  let(:definition) { YAML.safe_load_file(Rails.root.join("ops/discourse/cannlabs-prodlike.yml")) }

  describe "Qualified Access plugin pin" do
    let(:plugin) { CannlabsCommunity::Bootstrap.manifest.fetch("plugin") }
    let(:plugin_commands) do
      Array(definition.dig("hooks", "after_code"))
        .flat_map { |step| Array(step.dig("exec", "cmd")) }
        .select { |command| command.include?(plugin["name"]) }
    end

    it "installs the repository and revision the bootstrap manifest audits" do
      expect(
        plugin_commands.grep(/git clone #{Regexp.escape(plugin["repository"])}/),
      ).not_to be_empty,
      "ops/discourse/cannlabs-prodlike.yml must clone #{plugin["repository"]}"

      expect(plugin_commands.flat_map { |command| command.scan(/\b\h{40}\b/) }).to eq(
        [plugin["revision"]],
      ),
      "the plugin commit in ops/discourse/cannlabs-prodlike.yml must equal plugin.revision in " \
        "config/cannlabs_community/bootstrap.yml (#{plugin["revision"]})"
    end
  end

  describe "nginx credential-path redaction" do
    let(:outlet) do
      definition["run"]
        .filter_map { |step| step["file"] if step.is_a?(Hash) }
        .find { |file| file["path"].end_with?("35-cannlabs-log-redaction.conf") }
    end

    it "mirrors CannlabsPathSecretRedaction::RULES" do
      expect(outlet).to be_present, "the nginx log redaction outlet is missing from the definition"

      nginx_rules =
        outlet["contents"].lines.filter_map { |line| line[/\Aif \(\$uri ~ "(.+?)"\) \{/, 1] }
      app_rules =
        CannlabsPathSecretRedaction::RULES.map { |rule| "#{rule.source.sub("\\A", "^")}(.*)$" }

      expect(nginx_rules).to contain_exactly(*app_rules),
      "nginx $uri rules in ops/discourse/cannlabs-prodlike.yml must mirror " \
        "CannlabsPathSecretRedaction::RULES (config/initializers/zz-cannlabs-path-secret-redaction.rb)"
    end
  end
end
