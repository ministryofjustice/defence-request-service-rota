module RotaGeneration
  class RequirementWriter
    def initialize(slots, fact_file)
      @slots = slots
      @fact_file = fact_file
    end

    def write!
      shift_ids.each do |shift_id|
        date_range.each do |date|
          firms_required = slots.select { |s| s.shift_id == shift_id && s.date == date }.count
          fact_file.write(
            "slots_per_shift_date(#{shift_id},#{date.strftime("%a,%-d,%-m,%Y").downcase},#{firms_required}).\n"
          )
        end
      end
    end

    private

    attr_reader :slots, :fact_file

    def shift_ids
      slots.map(&:shift_id).uniq
    end

    def date_range
      unique_dates = slots.map(&:date).uniq
      (unique_dates.min..unique_dates.max)
    end
  end
end
