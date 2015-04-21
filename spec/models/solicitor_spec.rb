require "spec_helper"
require_relative "../../lib/service_registry"
require_relative "../../app/models/api_model"
require_relative "../../app/models/solicitor"

RSpec.describe Solicitor, ".all" do
  it "creates solicitor objects from the API response" do
    fake_response = [
      {
        "uid" => "1a2b3c",
        "name" => "Bob Smith",
        "type" => "solicitor",
        "links" => {
          "organisation" => "/api/v1/organisations/1234567890abcdef"
        }
      },
      {
        "uid" => "4d5e6f",
        "name" => "Andy Brown",
        "type" => "agent",
        "links" => {
          "organisation" => "/api/v1/organisations/2345678901bcdefa"
        }
      }
    ]

    fake_api = double(:data_api, solicitors: fake_response)

    allow(DefenceRequestServiceRota).to receive(:service).with(:auth_api).and_return(fake_api)

    expect(Solicitor.all.count).to eq 2
    expect(Solicitor.all[0].name).to eq "Bob Smith"
    expect(Solicitor.all[1].name).to eq "Andy Brown"
  end
end

RSpec.describe Solicitor, ".build_from" do
  it "builds a solicitor object from passed-in attributes" do
    attrs = {
      "uid" => "1a2b3c",
      "name" => "Bob Smith",
      "type" => "solicitor",
      "links" => {
        "organisation" => "/api/v1/organisations/1234567890abcdef"
      }
    }

    solicitor = Solicitor.build_from attrs

    expect(solicitor.uid).to eq "1a2b3c"
    expect(solicitor.name).to eq "Bob Smith"
    expect(solicitor.type).to eq "solicitor"
    expect(solicitor.organisation_link).to eq "/api/v1/organisations/1234567890abcdef"
  end
end
