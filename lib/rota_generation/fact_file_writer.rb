module RotaGeneration
  class FactFileWriter
    def initialize(slots, organisation_uids, fact_file)
      @slots = slots
      @organisation_uids = organisation_uids
      @fact_file = fact_file
    end

    def write!
      write_formatted_dates
      write_organisation_uids
      write_shift_ids
      write_requirements
      write_constants
    end

    private

    attr_reader :slots, :organisation_uids, :fact_file

    def write(str)
      fact_file.write(str)
      Rails.logger.info(str) if ENV.fetch("CLINGO_DEBUG", false)
    end

    def write_formatted_dates
      date_range.each do |date|
        write(date.strftime("date(%a, %-d, %-m, %Y).\n").downcase)
      end
    end

    def write_organisation_uids
      organisation_uids.each do |o_uid|
        write("firm(\"#{o_uid}\").\n")
      end
    end

    def write_shift_ids
      shift_ids.each do |s_id|
        write("shift(#{s_id}).\n")
      end
    end

    def write_requirements
      shift_ids.each do |shift_id|
        date_range.each do |date|
          write(
            "slots_per_shift_date(#{shift_id},#{format_date(date)},#{firm_count(shift_id, date)}).\n"
          )
        end
      end
    end

    def write_constants
      write("#const num_firms = #{number_of_firms}.\n")
      write("#const num_shifts = #{number_of_shifts}.\n")
      write("#const num_days = #{number_of_days}.\n")
      write("#const num_slots = #{number_of_slots}.\n")
    end

    def format_date(date)
      date.strftime("%a,%-d,%-m,%Y").downcase
    end

    def date_range
      if unique_dates.empty?
        []
      else
        (unique_dates.min..unique_dates.max)
      end
    end

    def unique_dates
      slots.map(&:starting_time).map(&:to_date).uniq
    end

    def shift_ids
      slots.map(&:shift_id).uniq
    end

    def firm_count(shift_id, date)
      slots.select { |slot| slot.shift_id == shift_id && slot.starting_time.to_date == date }.count
    end

    def number_of_firms
      organisation_uids.length
    end

    def number_of_shifts
      slots.map(&:shift_id).uniq.count
    end

    def number_of_days
      date_range.count
    end

    def number_of_slots
      slots.length
    end
  end
end
