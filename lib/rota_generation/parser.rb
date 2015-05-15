module RotaGeneration
  class Parser
    def parse!(raw_clingo_response)
      lines = raw_clingo_response.split("\n")

      unsatisfiable = lines.find { |l| l =~ /UNSATISFIABLE/ }

      return Unsatisfiable.new if unsatisfiable

      optimal_solution = lines.reverse.find do |l|
        l =~ /^allocated/
      end

      Solution.new(optimal_solution)
    end
  end
end
