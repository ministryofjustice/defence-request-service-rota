module RotaGeneration
  class ShiftWriter
    def initialize(slots, container_path)
      @slots = slots
      @container_path = container_path
    end

    def write!
      shift_ids = identify_shift_ids

      File.open(filename, "w+") do |f|
        shift_ids.each do |s_id|
          f.write("shift(#{s_id}).\n")
        end
      end
    end

    private

    attr_reader :slots, :container_path

    def filename
      File.join(container_path, "shifts.lp")
    end

    def identify_shift_ids
      slots.map(&:shift_id).uniq
    end
  end
end
