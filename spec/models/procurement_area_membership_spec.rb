require "rails_helper"

RSpec.describe ProcurementAreaMembership, "#save" do
  it "adds the procurement area to the member" do
    procurement_area = create(:procurement_area)
    organisations = double(:organisations)
    new_member = create(:organisation)

    membership_params = { id: new_member.id }

    ProcurementAreaMembership.new(
      procurement_area,
      organisations,
      membership_params
    ).save

    expect(new_member.reload.procurement_area).to eq procurement_area
  end

  it "does not add the membership if details are missing" do
    procurement_area = create(:procurement_area)
    organisations = double(:organisations)
    new_member = create(:organisation)
    membership_params = {}

    membership = ProcurementAreaMembership.new(
      procurement_area,
      organisations,
      membership_params
    ).save

    expect(membership).to eq false
    expect(new_member.procurement_area).to be_nil
  end
end

RSpec.describe ProcurementAreaMembership, "#destroy" do
  it "removes the procurement area relation from the member" do
    procurement_area = create(:procurement_area)
    organisations = []
    member = create(:organisation, procurement_area: procurement_area)
    membership_params = { id: member.id }

    ProcurementAreaMembership.new(procurement_area, organisations, membership_params).destroy

    expect(member.reload.procurement_area).to be_nil
    expect(procurement_area.reload.organisations).to be_empty
  end
end

RSpec.describe ProcurementAreaMembership do
  let(:procurement_area) { create(:procurement_area) }

  let!(:organisation_1) {
    create(:organisation,
           organisation_type: "custody_suite",
           procurement_area: procurement_area)
  }
  let!(:organisation_2) {
    create(:organisation,
           organisation_type: "law_office",
           procurement_area: procurement_area)
  }
  let!(:organisation_3) {
    create(:organisation,
           organisation_type: "law_firm")
  }
  let!(:organisation_4) {
    create(:organisation,
           organisation_type: "court")
  }

  subject { ProcurementAreaMembership.new(procurement_area, Organisation.all) }

  describe "#members" do
    it "returns only organisations with member types" do
      expect(subject.members).to     include(organisation_2, organisation_3)
      expect(subject.members).not_to include(organisation_1, organisation_4)
    end
  end

  describe "#eligible_members" do
    it "returns only organisations with member types which are unassigned" do
      expect(subject.eligible_members).to eq([organisation_3])
    end
  end

  describe "#current_members" do
    it "returns only organisations with member types which are assigned to the procurement area" do
      expect(subject.current_members).to eq([organisation_2])
    end
  end

  describe "#locations" do
    it "returns only organisations eligible to add as locations" do
      expect(subject.locations).to     include(organisation_1, organisation_4)
      expect(subject.locations).not_to include(organisation_2, organisation_3)
    end
  end

  describe "#eligible_locations" do
    it "returns only organisations with location types which are unassigned" do
      expect(subject.eligible_locations).to eq([organisation_4])
    end
  end

  describe "#current_locations" do
    it "returns only organisations with location types which are assigned to the procurement area" do
      expect(subject.current_locations).to eq([organisation_1])
    end
  end
end
