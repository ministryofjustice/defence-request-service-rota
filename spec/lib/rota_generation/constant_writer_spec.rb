require "spec_helper"
require_relative "../../../lib/rota_generation/constant_writer"

RSpec.describe RotaGeneration::ConstantWriter do
  describe "#write!" do
    before :each do
      slots = [
        double(:rota_slot, date: Date.parse("01-01-2015"), shift_id: 123),
        double(:rota_slot, date: Date.parse("01-01-2015"), shift_id: 789),
        double(:rota_slot, date: Date.parse("02-01-2015"), shift_id: 123),
        double(:rota_slot, date: Date.parse("02-01-2015"), shift_id: 789),
        double(:rota_slot, date: Date.parse("03-01-2015"), shift_id: 789),
      ]

      organisations = [
        double(:organisation),
        double(:organisation),
        double(:organisation),
        double(:organisation)
      ]

      @fake_file = StringIO.new

      RotaGeneration::ConstantWriter.new(slots, organisations, @fake_file).write!
    end

    it "writes out the number of firms" do
      expect(@fake_file.string).to match("#const num_firms = 4.")
    end

    it "writes out the number of shifts" do
      expect(@fake_file.string).to match("#const num_shifts = 2.")
    end

    it "writes out the number of days" do
      expect(@fake_file.string).to match("#const num_days = 3.")
    end

    it "writes out the number of slots" do
      expect(@fake_file.string).to match("#const num_slots = 5.")
    end
  end
end
