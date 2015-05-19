module RotaGeneration
  class Parser
    def initialize(clingo_response)
      @clingo_response = clingo_response
    end

    def parse!
      lines = clingo_response.split("\n")

      unsatisfiable = lines.find { |l| l =~ /UNSATISFIABLE/ }

      return Unsatisfiable.new if unsatisfiable

      optimal_solution = lines.reverse.find do |l|
        l =~ /^allocated/
      end

      Solution.new(optimal_solution)
    end

    private

    attr_reader :clingo_response
  end
end
