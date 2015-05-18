require "spec_helper"
require_relative "../../../lib/rota_generation/date_writer"

RSpec.describe RotaGeneration::DateWriter do
  describe "#write!" do
    it "writes out a range of unique dates which cover all slots" do
      slots = [
        double(:rota_slot, date: Date.parse("06-01-2015")),
        double(:rota_slot, date: Date.parse("06-01-2015")),
        double(:rota_slot, date: Date.parse("01-01-2015")),
        double(:rota_slot, date: Date.parse("05-01-2015"))
      ]

      fake_file = StringIO.new

      RotaGeneration::DateWriter.new(slots, fake_file).write!

      expect(fake_file.string).to eq <<-FILE
date(thu, 1, 1, 2015).
date(fri, 2, 1, 2015).
date(sat, 3, 1, 2015).
date(sun, 4, 1, 2015).
date(mon, 5, 1, 2015).
date(tue, 6, 1, 2015).
      FILE
    end
  end
end
