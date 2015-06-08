module RotaGeneration
  class ShiftWriter
    def initialize(slots, fact_file)
      @slots = slots
      @fact_file = fact_file
    end

    def write!
      shift_ids = identify_shift_ids

      shift_ids.each do |s_id|
        fact_file.write("shift(#{s_id}).\n")
      end
    end

    private

    attr_reader :slots, :fact_file

    def identify_shift_ids
      slots.map(&:shift_id).uniq
    end
  end
end
