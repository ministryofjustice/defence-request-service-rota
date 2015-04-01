require "spec_helper"
require_relative "../../app/models/organisation"

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
