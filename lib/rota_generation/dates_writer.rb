module RotaGeneration
  class DatesWriter
    def initialize(slots, container_path)
      @slots = slots
      @container_path = container_path
    end

    def write!
      date_range = identify_date_range

      File.open(File.join(container_path, "dates.lp"), "w+") do |f|
        date_range.each do |date|
          f.write(date.strftime("date(%a, %-d).\n").downcase)
        end
      end
    end

    private

    attr_reader :slots, :container_path

    def identify_date_range
      unique_dates = slots.pluck(:date).uniq
      (unique_dates.min..unique_dates.max)
    end
  end
end
