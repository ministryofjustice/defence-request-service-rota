require_relative "../../app/models/procurement_area_location"
require "ostruct"

RSpec.describe ProcurementAreaLocation, "#area_name" do
  it "returns the name of the passed in procurement area" do
    procurement_area = double(:procurement_area, name: "Example area")
    organisations = double(:organisations)

    location = ProcurementAreaLocation.new(procurement_area, organisations)

    expect(location.area_name).to eq "Example area"
  end
end

RSpec.describe ProcurementAreaLocation, "#area_id" do
  it "returns the id of the passed in procurement area" do
    procurement_area = double(:procurement_area, id: 1)
    organisations = double(:organisations)

    location = ProcurementAreaLocation.new(procurement_area, organisations)

    expect(location.area_id).to eq 1
  end
end

RSpec.describe ProcurementAreaLocation, "#save" do
  it "adds the location details to the procurement area" do
    procurement_area = spy(:procurement_area)
    organisations = double(:organisations)
    location_params = { uid: "123abc456", type: "example location" }

    ProcurementAreaLocation.new(procurement_area, organisations, location_params).save

    expect(procurement_area).to have_received(:push).with(
      uid: location_params[:uid],
      type: location_params[:type]
    )
    expect(procurement_area).to have_received(:save!)
  end

  it "does not add the location if details are missing" do
    procurement_area = spy(:procurement_area)
    organisations = double(:organisations)
    location_params = { uid: "", type: "" }

    location = ProcurementAreaLocation.new(procurement_area, organisations, location_params).save

    expect(location).to eq false
    expect(procurement_area).to_not have_received(:save!)
  end
end

RSpec.describe ProcurementAreaLocation, "#eligible_organisations" do
  it "returns only organisations eligible to add as locations" do
    existing_location = { uid: "123", type: "existing example" }
    procurement_area = double(:procurement_area, locations: [existing_location])
    organisations = [
      OpenStruct.new(uid: "345", type: "eligble location"),
      OpenStruct.new(uid: "123", type: "existing example"),
      OpenStruct.new(uid: "678", type: "eliglble location")
    ]

    location = ProcurementAreaLocation.new(procurement_area, organisations)

    expect(location.eligible_organisations).not_to include(organisations[1])
    expect(location.eligible_organisations).to include(organisations[0])
    expect(location.eligible_organisations).to include(organisations[2])
  end
end
