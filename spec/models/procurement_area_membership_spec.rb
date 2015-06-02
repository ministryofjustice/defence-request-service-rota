require "rails_helper"

RSpec.describe ProcurementAreaMembership, "#save" do
  it "adds the membership details to the procurement area" do
    procurement_area = spy(:procurement_area)
    organisations = double(:organisations)
    membership_params = { uid: "123abc456", type: "example membership" }

    ProcurementAreaMembership.new(procurement_area, organisations, membership_params).save

    expect(procurement_area).to have_received(:push).with(
      uid: membership_params[:uid],
      type: membership_params[:type]
    )
    expect(procurement_area).to have_received(:save!)
  end

  it "does not add the membership if details are missing" do
    procurement_area = spy(:procurement_area)
    organisations = double(:organisations)
    membership_params = { uid: "", type: "" }

    membership = ProcurementAreaMembership.new(procurement_area, organisations, membership_params).save

    expect(membership).to eq false
    expect(procurement_area).to_not have_received(:save!)
  end
end

RSpec.describe ProcurementAreaMembership, "#destroy" do
  it "removes the provided member from the procurement area memberships" do
    procurement_area = spy(:procurement_area)
    organisations = []
    membership_params = { uid: "abc123" }

    ProcurementAreaMembership.new(procurement_area, organisations, membership_params).destroy

    expect(procurement_area).to have_received(:destroy_membership!).with("abc123")
  end
end

RSpec.describe ProcurementAreaMembership, "#eligible_members" do
  it "returns only organisations eligible to add as members" do
    existing_membership = { uid: "123", type: "law_office" }
    procurement_area = build_stubbed(:procurement_area, memberships: [existing_membership])
    organisations = [
      OpenStruct.new(uid: "345", type: "custody_suite"),
      OpenStruct.new(uid: "123", type: "law_office"),
      OpenStruct.new(uid: "678", type: "law_firm"),
      OpenStruct.new(uid: "678", type: "court")
    ]

    membership = ProcurementAreaMembership.new(procurement_area, organisations)

    expect(membership.eligible_members).not_to include(organisations[1])
  end
end

RSpec.describe ProcurementAreaMembership, "#eligible_locations" do
  it "returns only organisations eligible to add as locations" do
    existing_membership = { uid: "123", type: "court" }
    procurement_area = build_stubbed(:procurement_area, memberships: [existing_membership])
    organisations = [
      OpenStruct.new(uid: "345", type: "custody_suite"),
      OpenStruct.new(uid: "123", type: "court"),
      OpenStruct.new(uid: "678", type: "law_firm"),
      OpenStruct.new(uid: "678", type: "court")
    ]

    membership = ProcurementAreaMembership.new(procurement_area, organisations)

    expect(membership.eligible_locations).not_to include(organisations[1])
  end
end
