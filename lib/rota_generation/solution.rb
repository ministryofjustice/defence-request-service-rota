module RotaGeneration
  class Solution
    def initialize(solution_string)
      @solution_string = solution_string
      @clauses = sanitize!
    end

    def sanitize!
      solution_string.split(/\s/)
    end

    def satisfiable?
      true
    end

    private

    attr_reader :solution_string, :clauses
  end
end
