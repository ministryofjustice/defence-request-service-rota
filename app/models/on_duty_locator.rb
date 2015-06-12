class OnDutyLocator
  def initialize(time, rota_slots)
    @time = time
    @rota_slots = rota_slots
  end

  def locate
    on_duty_organisation_uid
  end

  private

  attr_reader :time, :rota_slots

  def on_duty_organisation_uid
    slots_with_on_duty_shift.map(&:organisation_uid)
  end

  def slots_with_on_duty_shift
    applicable_slot = rota_slots.order(starting_time: :desc).detect { |slot| slot.starting_time <= time }

    if applicable_slot.nil? || (applicable_slot.ending_time.present? && applicable_slot.ending_time < time)
      []
    else
      rota_slots.where(starting_time: applicable_slot.starting_time, shift_id: applicable_slot.shift_id)
    end
  end
end
