require "rails_helper"

RSpec.describe LocationShiftForm, "#submit" do
  context "with valid data submission" do
    it "creates a shift from the data submitted" do
      data = {
        name: "Morning Shift",
        location_uid: SecureRandom.uuid,
        starting_time: Time.parse("08:00"),
        ending_time: Time.parse("10:00"),
      }
      form = LocationShiftForm.new(data)

      form.submit

      expect(form.location_shift).to be_an_instance_of(Shift)

      expect(form.location_shift.allocation_requirements_per_weekday).to eq ({
        "monday" => 1,
        "tuesday" => 1,
        "wednesday" => 1,
        "thursday" => 1,
        "friday" => 1,
        "saturday" => 1,
        "sunday" => 1,
        "bank_holiday" => 0
      })
    end
  end

  context "with invalid data submission" do
    it "does not create a shift" do
      data = { location_uid: "", starting_time: "" }
      form = LocationShiftForm.new(data)

      expect(Shift).not_to receive(:create!)
      expect(form.submit).to eq false
      expect(form.errors.full_messages).to eq(
        ["Location uid can't be blank", "Starting time can't be blank"]
      )
    end
  end
end
