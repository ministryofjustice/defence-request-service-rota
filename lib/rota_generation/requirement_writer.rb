module RotaGeneration
  class RequirementWriter
    def initialize(slots, fact_file)
      @slots = slots
      @fact_file = fact_file
    end

    def write!
      shifts.each do |shift|
        date_range.each do |date|
          firms_required = shift.
            allocation_requirements_per_weekday[date.strftime("%A").downcase]
          fact_file.write(
            "slots_per_shift_date(#{shift.id},#{date.strftime("%a,%-d,%-m,%Y").downcase},#{firms_required}).\n"
          )
        end
      end
    end

    private

    attr_reader :slots, :fact_file

    def shifts
      Shift.where(id: shift_ids)
    end

    def shift_ids
      slots.map(&:shift_id).uniq
    end

    def date_range
      unique_dates = slots.map(&:date).uniq
      (unique_dates.min..unique_dates.max)
    end
  end
end
