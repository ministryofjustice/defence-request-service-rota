module RotaGeneration
  class DateWriter
    def initialize(slots, fact_file)
      @slots = slots
      @fact_file = fact_file
    end

    def write!
      date_range = identify_date_range

      date_range.each do |date|
        fact_file.write(date.strftime("date(%a, %-d, %-m, %Y).\n").downcase)
      end
    end

    private

    attr_reader :slots, :fact_file

    def identify_date_range
      unique_dates = slots.map(&:date).uniq
      unless unique_dates.empty?
        (unique_dates.min..unique_dates.max)
      else
        []
      end
    end
  end
end
