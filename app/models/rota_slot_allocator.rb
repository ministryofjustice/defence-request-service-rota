class RotaSlotAllocator
  def initialize(date_range:, shifts:, procurement_area:)
    @date_range = date_range
    @shifts = shifts
    @procurement_area = procurement_area
  end

  def allocate
    allocation_requirements_per_shift
  end

  private

  attr_reader :date_range, :shifts, :procurement_area

  def allocation_requirements_per_shift
    shifts.inject([]) do |result, shift|
      date_range.each do |date|
        slot_count = shift.public_send(date.strftime("%A").downcase.to_sym).to_i
        slot_count.times do |_|
          result << RotaSlot.new(
            shift_id: shift.id,
            starting_time: compose_date_and_shift_time(date, shift.starting_time),
            ending_time: compose_date_and_shift_time(date, shift.ending_time),
            procurement_area: procurement_area
          )
        end
      end
      result
    end
  end

  def compose_date_and_shift_time(date, time)
    if time.nil?
      nil
    else
      DateTime.new(date.year, date.month, date.day, time.hour, time.min, time.sec, time.zone)
    end
  end
end
