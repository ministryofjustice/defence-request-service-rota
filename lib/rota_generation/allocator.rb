module RotaGeneration
  class Allocator
    def initialize(slots)
      @slots = slots
    end

    def mutate_slots!(solution_clauses)
      solution_clauses.each do |clause|
        shift_id, date_of_month, month, year, firm_uid = split_clause(clause)
        date = Date.new(year.to_i, month.to_i, date_of_month.to_i)
        matching_slot = slots.detect { |s| s.date == date && s.shift_id == shift_id.to_i }
        matching_slot.organisation_uid = firm_uid
        matching_slot.save!
      end
    end

    private

    def split_clause(clause)
      clause.match(/allocated\(([^,]*),[^,]*,(\d+),(\d+),(\d+),\"([^,]*)\"\)/).captures
    end

    attr_reader :slots, :solution
  end
end
