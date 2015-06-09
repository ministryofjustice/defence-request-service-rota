require "spec_helper"
require "active_support/core_ext/string/strip"
require_relative "../../../lib/rota_generation/parser"
require_relative "../../../lib/rota_generation/unsatisfiable"
require_relative "../../../lib/rota_generation/solution"

RSpec.describe RotaGeneration::Parser do
  describe "#parse!" do
    context "with an unsatisfiable response" do
      it "returns an Unsatisfiable object" do
        parser = RotaGeneration::Parser.new("UNSATISFIABLE")

        expect(parser.parse!).to be_an(RotaGeneration::Unsatisfiable)
      end
    end

    context "with a satisfiable response" do
      it "returns a Solution with the last answer provided" do
        example_unparsed_response = <<-RESPONSE.strip_heredoc
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

        parser = RotaGeneration::Parser.new(example_unparsed_response)

        expect(RotaGeneration::Solution).to receive(:new).with("allocated(1,thu,7,5,2015,d)")

        parser.parse!
      end
    end

    context "with an empty satisfiable response" do
      it "returns an Unsatisfiable object" do
        example_response = <<-RESPONSE.strip_heredoc
          Answer: 1

        RESPONSE

        parser = RotaGeneration::Parser.new(example_response)

        expect(parser.parse!).to be_an(RotaGeneration::Unsatisfiable)
      end
    end
  end
end
