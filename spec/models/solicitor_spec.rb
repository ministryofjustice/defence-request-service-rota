require "spec_helper"
require_relative "../../app/models/solicitor"

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
