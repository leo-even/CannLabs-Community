# frozen_string_literal: true

RSpec.describe "CannLabs logging hygiene" do
  sensitive = %w[
    code
    state
    token
    access_token
    refresh_token
    id_token
    client_secret
    authenticity_token
  ]
  visible = %w[country_code invite_code]

  let(:parameter_filter) do
    ActiveSupport::ParameterFilter.new(Rails.application.config.filter_parameters)
  end

  it "filters sensitive parameters by exact name" do
    filtered = parameter_filter.filter(sensitive.index_with { "sentinel-value" })

    expect(filtered.values).to all(eq("[FILTERED]"))
  end

  it "does not filter names that merely contain a sensitive word" do
    filtered = parameter_filter.filter(visible.index_with { "br" })

    expect(filtered.values).to all(eq("br"))
  end

  it "keeps the upstream filters" do
    filtered =
      parameter_filter.filter("password" => "sentinel-value", "api_key" => "sentinel-value")

    expect(filtered.values).to all(eq("[FILTERED]"))
  end

  it "filters sensitive values in the logged request path" do
    query = (sensitive + visible).map { |name| "#{name}=sentinel-value" }.join("&")
    request =
      ActionDispatch::Request.new(
        Rack::MockRequest.env_for("/auth/example/callback?#{query}").merge(
          Rails.application.env_config,
        ),
      )
    filtered = Rack::Utils.parse_query(URI(request.filtered_path).query)

    expect(filtered.slice(*sensitive).values).to all(eq("[FILTERED]"))
    expect(filtered.slice(*visible).values).to all(eq("sentinel-value"))
  end
end
