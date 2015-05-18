module RotaGeneration
  class ConstantWriter
    def initialize(slots, organisation_uids, fact_file)
      @slots = slots
      @organisation_uids = organisation_uids
      @fact_file = fact_file
    end

    def write!
      fact_file.write("#const num_firms = #{num_firms}.\n")
      fact_file.write("#const num_shifts = #{num_shifts}.\n")
      fact_file.write("#const num_days = #{num_days}.\n")
      fact_file.write("#const num_slots = #{num_slots}.\n")
    end

    private

    attr_reader :slots, :organisation_uids, :fact_file

    def num_firms
      organisation_uids.length
    end

    def num_shifts
      slots.map(&:shift_id).uniq.count
    end

    def num_days
      dates = slots.map(&:date).uniq
      unless dates.empty?
        (dates.min..dates.max).count
      else
        0
      end
    end

    def num_slots
      slots.length
    end
  end
end
