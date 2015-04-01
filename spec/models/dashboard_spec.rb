require "spec_helper"
require_relative "../../app/models/api_model"
require_relative "../../app/models/solicitor"
require_relative "../../app/models/organisation"
require_relative "../../app/models/dashboard"

RSpec.describe Dashboard, "#solicitors" do
  it "asks for all Solicitor objects" do
    expect(Solicitor).to receive(:all)

    subject.solicitors
  end
end

RSpec.describe Dashboard, "#organisations" do
  it "returns a list of Organisation objects" do
    fake_response = {
      "organisations": [
        {
          "id": 1,
          "name": "Tuckers",
          "type": "law_firm",
          "profile_ids": [1,2,3,5,6,7]
        },
        {
          "id": 2,
          "name": "Brighton",
          "type": "custody_suite",
          "profile_ids": [5,8,9]
        }
      ]
    }

    fake_data_api = double(
      :data_api,
      organisations: fake_response,
    )

    dashboard = Dashboard.new(fake_data_api)

    expect(dashboard.organisations.map(&:name)).to eq ["Tuckers", "Brighton"]
  end
end
