require "rails_helper"

RSpec.describe Shift, "validations" do
  it { should validate_presence_of(:location_uid) }
  it { should validate_presence_of(:starting_time) }
end

RSpec.describe Shift, ".for" do
  it "returns the shifts for a given location" do
    location = double(:location, uid: "1")
    create :shift, name: "Shift for location 1", location_uid: location.uid
    create :shift, name: "Other shift"
    create :shift, name: "Late Shift for location 1", location_uid: location.uid

    location_shifts = Shift.for(location)

    expect(location_shifts.map(&:name)).to eq(
      ["Late Shift for location 1", "Shift for location 1"]
    )
  end
end
