require "spec_helper"
require_relative "../../app/models/solicitor"
require_relative "../../app/models/dashboard"

RSpec.describe Dashboard, "#solicitors" do
  it "returns a list of Solicitor objects" do
    fake_response = {
      "profiles": [
        {
          "id": 1,
          "name": "Bob Smith",
          "type": "solicitor"
        },
        {
          "id": 2,
          "name": "Andy Brown",
          "type": "agent"
        }
      ]
    }

    fake_data_api = double(:data_api, solicitors: fake_response)

    dashboard = Dashboard.new(fake_data_api)

    expect(dashboard.solicitors.map(&:name)).to eq ["Bob Smith", "Andy Brown"]
  end
end
