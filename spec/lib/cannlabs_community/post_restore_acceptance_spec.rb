# frozen_string_literal: true

# Guards the post-restore acceptance contract (ops/discourse/README.md, section 10, DEC-045) and the anonymous
# HTTP acceptance script it requires. A native restore can leave running workers serving pre-restore settings
# while /srv/status stays ok, so acceptance needs a restart, an audit and a live anonymous HTTP gate.
RSpec.describe "Post-restore acceptance contract" do # rubocop:disable RSpec/DescribeClass
  let(:readme) { File.read(Rails.root.join("ops/discourse/README.md")) }
  let(:script_path) { Rails.root.join("ops/discourse/anonymous_http_acceptance.py") }
  let(:script) { File.read(script_path) }
  let(:contract) { readme[/^## 10\. .*?(?=^## \d+\. )/m] || raise("README.md has no section 10") }
  let(:steps) { contract.lines.grep(/\A\d\. /) }

  it "orders restore, restart, health, audit, live HTTP gate and validation" do
    keywords = [
      "[SUCCESS]",
      "./launcher restart",
      "/srv/status",
      "cannlabs_community:bootstrap:audit",
      "anonymous_http_acceptance.py",
      "VALIDATED",
    ]

    expect(steps.size).to eq(keywords.size)
    steps
      .zip(keywords)
      .each_with_index do |(step, keyword), index|
        expect(step).to start_with("#{index + 1}. ")
        expect(step).to include(keyword)
      end
  end

  it "restarts the existing container and never asks for a rebuild" do
    expect(steps[1]).to include("existing")
    expect(steps.join).not_to include("./launcher rebuild")
    expect(steps[1]).to match(/Do not substitute `rebuild`/)
  end

  it "keeps /srv/status liveness-only and a backup restart-free" do
    expect(contract).to match(%r{`/srv/status` is a liveness check})
    expect(contract).to match(/necessary and never sufficient/)
    expect(contract).to match(/A backup changes nothing underneath the running application/)
    expect(contract).to match(/needs no restart/)
  end

  it "treats an inconclusive gate as not a pass" do
    expect(steps[4]).to include("HTTP_ACCEPTANCE=PASS")
    expect(steps.last).to match(/INCONCLUSIVE.*not a pass/)
  end

  it "ships an anonymous, GET-only, standard-library gate" do
    imports = script.scan(/^(?:import|from) (\w+)/).flatten.uniq
    stdlib = %w[argparse io json re sys time urllib collections]

    expect(imports - stdlib).to be_empty, "non-standard imports: #{(imports - stdlib).join(", ")}"
    expect(script).not_to match(/HTTPCookieProcessor|CookieJar|Authorization|Bearer|Api-Key/i)
    expect(script).not_to match(/Request\(.*\b(?:data|method)\s*=/)
    expect(script).not_to match(/os\.environ|getpass|password/i)
  end

  it "documents the flags and exit statuses that the contract relies on" do
    %w[--base-url --host-header --expect-locale --require-noindex --self-test].each do |flag|
      expect(script).to include(flag)
      expect(contract).to include(flag)
    end
    expect(script).to match(/Exit status: 0 PASS, 1 FAIL, 2 INCONCLUSIVE/)
  end

  it "passes its own mutation-tested self-test" do
    unless system("python3 --version > /dev/null 2>&1")
      skip "python3 is not installed in this environment"
    end

    output = IO.popen(["python3", script_path.to_s, "--self-test"], err: %i[child out], &:read)

    expect(Process.last_status).to be_success, output.lines.grep(/FAIL/).join
    expect(output).to match(%r{SELF_TEST=PASS \(\d+/\d+\)})
  end
end
