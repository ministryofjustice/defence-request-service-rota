require_relative "../../app/models/dashboard"

RSpec.describe Dashboard, "#organisations" do
  it "asks for all Organisation objects" do
    organisations = double(:organisations)

    dashboard = Dashboard.new(organisations)

    expect(dashboard.organisations).to eq organisations
  end
end
