module RotaGeneration
  class RequirementWriter
    def initialize(slots, container_path)
      @slots = slots
      @container_path = container_path
    end

    def write!
      File.open(filename, "w+") do |f|
        shifts.each do |shift|
          date_range.each do |date|
            firms_required = shift.
                             allocation_requirements_per_weekday[date.strftime("%A").downcase]
            f.write(
              "slots_per_shift_date(#{shift.id},#{date.strftime("%a,%-d").downcase},#{firms_required}).\n"
            )
          end
        end
      end
    end

    private

    attr_reader :slots, :container_path

    def shifts
      Shift.where(id: shift_ids)
    end

    def shift_ids
      slots.map(&:shift_id).uniq
    end

    def filename
      File.join(container_path, "per_day.lp")
    end

    def date_range
      unique_dates = slots.map(&:date).uniq
      (unique_dates.min..unique_dates.max)
    end
  end
end
