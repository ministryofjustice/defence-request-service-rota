require "spec_helper"
require_relative "../../../lib/rota_generation/parser"
require_relative "../../../lib/rota_generation/unsatisfiable"
require_relative "../../../lib/rota_generation/solution"

RSpec.describe RotaGeneration::Parser do
  describe "#parse!" do
    context "with an unsatisfiable response" do
      subject { RotaGeneration::Parser.new("UNSATISFIABLE") }

      it "returns an Unsatisfiable object" do
        expect(subject.parse!).to be_an(RotaGeneration::Unsatisfiable)
      end
    end

    context "with a satisfiable response" do
      subject { RotaGeneration::Parser.new(<<-RESPONSE
Answer: 1
allocated(1,thu,7,5,2015,a)
Optimization: 3
Answer: 2
allocated(1,thu,7,5,2015,b)
Optimization: 2
Answer: 3
allocated(1,thu,7,5,2015,c)
Optimization: 1
Answer: 4
allocated(1,thu,7,5,2015,d)
      RESPONSE
      )}

      it "returns a Solution with the last answer provided" do
        expect(RotaGeneration::Solution).to receive(:new).with("allocated(1,thu,7,5,2015,d)")

        subject.parse!
      end
    end
  end
end
