require "spec_helper"
require_relative "../../../lib/rota_generation/requirement_writer"

RSpec.describe RotaGeneration::RequirementWriter do
  describe "#write!" do
    it "prints out the requirements for shifts over the date range" do
      thursday = Date.parse("01-01-2015")
      friday   = Date.parse("02-01-2015")

      slots = [
        double(:rota_slot, date: thursday, shift_id: 123),
        double(:rota_slot, date: thursday, shift_id: 123),
        double(:rota_slot, date: friday,   shift_id: 123),
        double(:rota_slot, date: friday,   shift_id: 123),
        double(:rota_slot, date: friday,   shift_id: 123)
      ]

      fake_file = StringIO.new

      RotaGeneration::RequirementWriter.new(slots, fake_file).write!

      expect(fake_file.string).to eq <<-FILE
slots_per_shift_date(123,thu,1,1,2015,2).
slots_per_shift_date(123,fri,2,1,2015,3).
      FILE
    end
  end
end
