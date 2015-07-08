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
    slots = []
    shifts.inject(slots) do |result, shift|
      date_range.each do |date|
        result << allocations_for_shift_date(shift, date)
      end
      result
    end
    slots.compact
  end

  def allocations_for_shift_date(shift, date)
    if date.is_bank_holiday?
      slot_count = shift.bank_holiday.to_i
    else
      slot_count = shift.public_send(date.strftime("%A").downcase.to_sym).to_i
    end

    unless slot_count.zero?
      RotaSlot.new(
        new_slot_attributes(date, shift, slot_count)
      )
    end
  end

  def new_slot_attributes(date, shift, slot_count)
    {
      shift_id: shift.id,
      starting_time: rota_slot_start_time(date, shift),
      ending_time: rota_slot_end_time(date, shift),
      procurement_area: procurement_area,
      number_of_firms_required: slot_count
    }
  end

  def rota_slot_start_time(date, shift)
    shift_start_time = shift.starting_time

    compose_date_and_time(date, shift_start_time)
  end

  def rota_slot_end_time(date, shift)
    return nil if shift.ending_time.nil?

    slot_end_time = compose_date_and_time(date, shift.ending_time)

    shift.spans_two_days? ? slot_end_time.advance(days: 1) : slot_end_time
  end

  def compose_date_and_time(date, time)
    Time.new(date.year,
             date.month,
             date.day,
             time.hour,
             time.min,
             time.sec)
  end
end
