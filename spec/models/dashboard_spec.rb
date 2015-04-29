require_relative "../../app/models/dashboard"

RSpec.describe Dashboard, "#organisations" do
  it "asks for all Organisation objects" do
    organisations = double(:organisations)
    solicitors = double(:solicitors)

    dashboard = Dashboard.new(organisations, solicitors)

    expect(dashboard.organisations).to eq organisations
  end
end

RSpec.describe Dashboard, "#solicitors" do
  it "asks for all Solicitor objects" do
    organisations = double(:organisations)
    solicitors = double(:solicitors)

    dashboard = Dashboard.new(organisations, solicitors)

    expect(dashboard.solicitors).to eq solicitors
  end
end
