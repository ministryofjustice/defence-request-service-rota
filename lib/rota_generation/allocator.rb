module RotaGeneration
  class Allocator
    def mutate_slots!(slots, solution_clauses)
      solution_clauses.each do |clause|
        shift_id, date_of_month, month, year, firm_uid = split_clause(clause)
        date = Date.new(year.to_i, month.to_i, date_of_month.to_i)
        matching_slot = slots.detect { |s| s.date == date && s.shift_id == shift_id.to_i && s.organisation_uid == nil }
        matching_slot.organisation_uid = firm_uid if matching_slot
      end

      slots
    end

    private

    def split_clause(clause)
      clause.match(/allocated\(([^,]*),[^,]*,(\d+),(\d+),(\d+),\"([^,]*)\"\)/).captures
    end
  end
end
