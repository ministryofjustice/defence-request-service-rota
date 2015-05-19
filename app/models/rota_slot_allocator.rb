class RotaSlotAllocator
  def initialize(date_range:, shifts:)
    @date_range = date_range
    @shifts = shifts
  end

  def allocate
    allocation_requirements_per_shift
  end

  private

  attr_reader :date_range, :shifts

  def allocation_requirements_per_shift
    shifts.inject([]) do |result, shift|
      date_range.each do |date|
        slot_count = shift.public_send(date.strftime("%A").downcase.to_sym)
        slot_count.times do |_|
          result << RotaSlot.new(shift_id: shift.id, date: date)
        end
      end
      result
    end
  end
end
