require "spec_helper"
require_relative "../../lib/service_registry"
require_relative "../../app/models/api_model"
require_relative "../../app/models/organisation"

RSpec.describe Organisation, ".all" do
  it "creates organisation objects from the API response" do
    fake_response = [
      {
        "uid" => "1234567890abcdef",
        "name" => "Tuckers",
        "type" => "law_firm",
        "links" => {
          "profiles" => "/api/v1/profiles?uids[]=1a2b3c&uids[]=4d5e6f&uids[]=a1b2c3"
        }
      },
      {
        "uid" => "0987654321fedcba",
        "name" => "Brighton",
        "type" => "custody_suite",
        "links" => {
          "profiles" => "/api/v1/profiles?uids[]=0f9e8d&uids[]=7c6b5a"
        }
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
      "uid" => "1234567890abcdef",
      "name" => "Tuckers",
      "type" => "law_firm",
      "links" => {
        "profiles" => "/api/v1/profiles?uids[]=1a2b3c&uids[]=4d5e6f&uids[]=a1b2c3"
      }
    }

    organisation = Organisation.build_from attrs

    expect(organisation.uid).to eq "1234567890abcdef"
    expect(organisation.name).to eq "Tuckers"
    expect(organisation.type).to eq "law_firm"
    expect(organisation.profiles_link).to eq "/api/v1/profiles?uids[]=1a2b3c&uids[]=4d5e6f&uids[]=a1b2c3"
  end
end
