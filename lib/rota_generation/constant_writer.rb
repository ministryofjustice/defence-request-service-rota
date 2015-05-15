module RotaGeneration
  class ConstantWriter
    def initialize(slots, organisations, container_path)
      @slots = slots
      @organisations = organisations
      @container_path = container_path
    end

    def write!
      File.open(filename, "w+") do |f|
        f.write("#const num_firms = #{num_firms}.\n")
        f.write("#const num_shifts = #{num_shifts}.\n")
        f.write("#const num_days = #{num_days}.\n")
        f.write("#const num_slots = #{num_slots}.\n")
      end
    end

    private

    attr_reader :slots, :organisations, :container_path

    def filename
      File.join(container_path, "constants.lp")
    end

    def num_firms
      organisations.length
    end

    def num_shifts
      slots.map(&:shift_id).uniq.count
    end

    def num_days
      dates = slots.map(&:date).uniq
      (dates.min..dates.max).count
    end

    def num_slots
      slots.length
    end
  end
end
