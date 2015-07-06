require "rails_helper"

RSpec.describe JournalEntry, "validations" do
  it { should validate_presence_of(:procurement_area_id) }
  it { should validate_presence_of(:total_slots) }
  it { should validate_presence_of(:start_time) }
  it { should validate_presence_of(:status) }
  it { should allow_value("running").for(:status) }
  it { should_not allow_value("garbage").for(:status) }
  it { should allow_value(nil).for(:end_time) }

  it "does not allow a end time before the start time" do
    expect(
      JournalEntry.new(
        procurement_area_id: 1,
        total_slots: 100,
        start_time: Time.now,
        end_time: (Time.now - 1.second),
        status: "failed"
      )
    ).not_to be_valid
  end
end
