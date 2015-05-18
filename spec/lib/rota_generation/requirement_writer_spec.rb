require "spec_helper"
require_relative "../../../lib/rota_generation/requirement_writer"

RSpec.describe RotaGeneration::RequirementWriter do
  describe "#write!" do
    it "prints out the requirements for shifts over the date range" do
      thursday = Date.parse("01-01-2015")
      friday   = Date.parse("02-01-2015")

      shift = double(:shift, id: 123, allocation_requirements_per_weekday: {
        "monday" => "1",
        "tuesday" => "1",
        "wednesday" => "1",
        "thursday" => "3",
        "friday" => "4",
        "saturday" => "1",
        "sunday" => "1",
      })

      slots = [
        double(:rota_slot, date: thursday, shift_id: 123),
        double(:rota_slot, date: friday,   shift_id: 123)
      ]

      fake_file = StringIO.new

      RotaGeneration::RequirementWriter.new(slots, [shift], fake_file).write!

      expect(fake_file.string).to eq <<-FILE
slots_per_shift_date(123,thu,1,1,2015,3).
slots_per_shift_date(123,fri,2,1,2015,4).
      FILE
    end
  end
end
