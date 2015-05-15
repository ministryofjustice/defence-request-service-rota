module RotaGeneration
  class Solution
    def initialize(solution_string)
      @solution_string = solution_string
    end

    def clauses
      sanitize!
    end

    def satisfiable?
      true
    end

    private

    def sanitize!
      solution_string.split(/\s/)
    end

    attr_reader :solution_string
  end
end
