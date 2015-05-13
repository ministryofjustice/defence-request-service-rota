require_relative "../../app/models/location_shift"
require "active_support/core_ext/time/conversions"

RSpec.describe LocationShift, "#info" do
  context "for a shift with starting and ending time" do
    it "returns a representation of the shift information" do
      shift = double(
        :shift,
        name: "Example shift",
        starting_time: Time.parse("08:00"),
        ending_time: Time.parse("17:00")
      )

      location_shift_info = LocationShift.new(shift).info

      expect(location_shift_info).to eq "Example shift - 08:00 / 17:00"
    end
  end

  context "for a shift with only a name and starting time" do
    it "returns a representation of the shift information" do
      shift = double(
        :shift,
        name: "Example shift",
        starting_time: Time.parse("08:00"),
        ending_time: nil
      )

      location_shift_info = LocationShift.new(shift).info

      expect(location_shift_info).to eq "Example shift - 08:00 / until release"
    end
  end

  context "for a shift without a name" do
    it "returns a representation of the shift information" do
      shift = double(
        :shift,
        name: "",
        starting_time: Time.parse("08:00"),
        ending_time: Time.parse("17:00")
      )

      location_shift_info = LocationShift.new(shift).info

      expect(location_shift_info).to eq "N/A - 08:00 / 17:00"
    end
  end
end
