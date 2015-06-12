module RotaGeneration
  class Allocator
    def initialize(slots, solution_clauses)
      @slots = slots
      @solution_clauses = solution_clauses
    end

    def mutate_slots!
      split_clauses.each do |shift_id, date_of_month, month, year, firm_uid|
        matching_slot = detect_matching_slot(build_date(year, month, date_of_month), shift_id)
        matching_slot.organisation_uid = firm_uid if matching_slot
      end
      slots
    end

    private

    attr_reader :slots, :solution_clauses

    def split_clauses
      solution_clauses.map do |clause|
        clause.
          match(/allocated\(([^,]*),[^,]*,(\d+),(\d+),(\d+),\"([^,]*)\"\)/).
          captures
      end
    end

    def build_date(year, month, date_of_month)
      Date.new(year.to_i, month.to_i, date_of_month.to_i)
    end

    def detect_matching_slot(date, shift_id)
      slots.detect do |slot|
        slot.starting_time.to_date == date &&
          slot.shift_id == shift_id.to_i &&
          slot.organisation_uid == nil
      end
    end
  end
end
