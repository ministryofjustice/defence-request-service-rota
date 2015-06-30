require "rails_helper"

RSpec.describe Shift, "validations" do
  it { should validate_presence_of(:organisation) }
  it { should validate_presence_of(:starting_time) }
end

RSpec.describe Shift, "relationships" do
  it { should have_many(:rota_slots) }
  it { should belong_to(:organisation) }
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
