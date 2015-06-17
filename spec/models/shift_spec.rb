require "rails_helper"

RSpec.describe Shift, "validations" do
  it { should validate_presence_of(:location_uid) }
  it { should validate_presence_of(:starting_time) }
end

RSpec.describe Shift, ".for" do
  it "returns the shifts for a given location" do
    location_uid = "1"
    create :shift, name: "Shift for location 1", location_uid: "1"
    create :shift, name: "Other shift"
    create :shift, name: "Late Shift for location 1", location_uid: "1"

    location_shifts = Shift.for([location_uid])

    expect(location_shifts.map(&:name)).to eq(
      ["Late Shift for location 1", "Shift for location 1"]
    )
  end
end

RSpec.describe Shift, "#spans_two_days?" do
  it "returns false if there is no ending time" do
    shift = build :shift, starting_time: "09:00"

    expect(shift.spans_two_days?).to be_falsey
  end

  it "returns false if the ending time falls later in the same day as the start time" do
    shift = build :shift, starting_time: "09:00", ending_time: "17:00"

    expect(shift.spans_two_days?).to be_falsey
  end

  it "returns true if the ending time falls earlier (and therefore the next day)" do
    shift = build :shift, starting_time: "17:00", ending_time: "09:00"

    expect(shift.spans_two_days?).to be_truthy
  end
end
