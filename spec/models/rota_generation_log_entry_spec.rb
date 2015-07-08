require "rails_helper"

RSpec.describe RotaGenerationLogEntry, "validations" do
  it { should validate_presence_of(:procurement_area_id) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:total_slots) }
  it { should validate_presence_of(:start_time) }
  it { should validate_presence_of(:status) }
  it { should allow_value("running").for(:status) }
  it { should_not allow_value("garbage").for(:status) }
  it { should allow_value(nil).for(:end_time) }

  it "does not allow a end time before the start time" do
    expect(
      RotaGenerationLogEntry.new(
        procurement_area_id: 1,
        user_id: 1,
        total_slots: 100,
        start_time: Time.now,
        end_time: (Time.now - 1.second),
        status: "failed"
      )
    ).not_to be_valid
  end
end

RSpec.describe RotaGenerationLogEntry, "relationships" do
  it { should belong_to(:user) }
  it { should belong_to(:procurement_area) }
end

RSpec.describe RotaGenerationLogEntry, "scopes" do
  describe ".newest_first" do
    it "returns entries in reverse start_time order" do
      p1 = create(:rota_generation_log_entry, start_time: 4.hours.ago)
      p2 = create(:rota_generation_log_entry, start_time: 4.days.ago)
      p3 = create(:rota_generation_log_entry, start_time: 4.minutes.ago)

      expect(RotaGenerationLogEntry.newest_first).to eq [p3, p1, p2]
    end
  end

  describe ".latest" do
    it "returns at most five of the most recent entries" do
      p1 = create(:rota_generation_log_entry, start_time: 4.years.ago)
      p2 = create(:rota_generation_log_entry, start_time: 4.days.ago)
      p3 = create(:rota_generation_log_entry, start_time: 4.minutes.ago)
      p4 = create(:rota_generation_log_entry, start_time: 4.hours.ago)
      p5 = create(:rota_generation_log_entry, start_time: 40.years.ago)
      p6 = create(:rota_generation_log_entry, start_time: 4.seconds.ago)
      p7 = create(:rota_generation_log_entry, start_time: 4.months.ago)

      expect(RotaGenerationLogEntry.latest).to eq [p6, p3, p4, p2, p7]
      expect(RotaGenerationLogEntry.latest).not_to include(p1, p5)
    end
  end
end
