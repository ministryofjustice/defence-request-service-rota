require "spec_helper"
require_relative "../../../lib/rota_generation/shift_writer"

RSpec.describe RotaGeneration::ShiftWriter do
  describe "#write!" do
    it "writes out the unique shift_ids" do
      slots = [
        double(:rota_slot, shift_id: 123),
        double(:rota_slot, shift_id: 234),
        double(:rota_slot, shift_id: 123),
        double(:rota_slot, shift_id: 847)
      ]

      fake_file = StringIO.new

      RotaGeneration::ShiftWriter.new(slots, fake_file).write!

      expect(fake_file.string).to eq <<-FILE
shift(123).
shift(234).
shift(847).
      FILE
    end
  end
end
