require "spec_helper"
require_relative "../../lib/service_registry"
require_relative "../../app/models/api_model"
require_relative "../../app/models/organisation"

RSpec.describe Organisation, ".all" do
  it "creates organisation objects from the API response" do
    fake_response = [
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

    fake_api = double(:data_api, organisations: fake_response)

    allow(DefenceRequestServiceRota).to receive(:service).with(:auth_api).and_return(fake_api)

    expect(Organisation.all.count).to eq 2
    expect(Organisation.all[0].name).to eq "Tuckers"
    expect(Organisation.all[1].name).to eq "Brighton"
  end
end

RSpec.describe Organisation, ".build_from" do
  it "builds an organisation object from passed-in attributes" do
    attrs = {
      "id": 1,
      "name": "Tuckers",
      "type": "law_firm",
      "profile_ids": [1, 2, 3, 5, 6, 7]
    }

    organisation = Organisation.build_from attrs

    expect(organisation.id).to eq 1
    expect(organisation.name).to eq "Tuckers"
    expect(organisation.type).to eq "law_firm"
    expect(organisation.profile_ids).to eq [1, 2, 3, 5, 6, 7]
  end
end
