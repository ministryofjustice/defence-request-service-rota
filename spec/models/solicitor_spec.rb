require "spec_helper"
require_relative "../../app/models/api_model"
require_relative "../../app/models/solicitor"

RSpec.describe Solicitor, ".all" do
  it "creates solicitor objects from the API response" do
    fake_response = [
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

    fake_api = double(:data_api, solicitors: fake_response)

    allow(Solicitor).to receive(:data_api).and_return(fake_api)

    expect(Solicitor.all.count).to eq 2
    expect(Solicitor.all[0].name).to eq "Bob Smith"
    expect(Solicitor.all[1].name).to eq "Andy Brown"
  end
end

RSpec.describe Solicitor, ".build_from" do
  it "builds a solicitor object from passed-in attributes" do
    attrs = {
          "id": 1,
          "name": "Bob Smith",
          "type": "solicitor"
        }

    solicitor = Solicitor.build_from attrs

    expect(solicitor.id).to eq 1
    expect(solicitor.name).to eq "Bob Smith"
    expect(solicitor.type).to eq "solicitor"
  end
end
