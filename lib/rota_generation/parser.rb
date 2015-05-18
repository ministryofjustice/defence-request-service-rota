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

    def mutate_slots!(slots, solution_clauses)
      solution_clauses.each do |clause|
        shift_id, date_of_month, month, year, firm_uid = split_clause(clause)
        date = Date.new(year.to_i, month.to_i, date_of_month.to_i)
        matching_slot = slots.detect { |s| s.date == date && s.shift_id == shift_id.to_i }
        matching_slot.organisation_uid = firm_uid
      end

      slots
    end

    private

    attr_reader :clingo_response

    def split_clause(clause)
      clause.match(/allocated\(([^,]*),[^,]*,(\d+),(\d+),(\d+),\"([^,]*)\"\)/).captures
    end
  end
end
