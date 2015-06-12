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
    slot_with_on_duty_shift.organisation_uid
  end

  def slot_with_on_duty_shift
    rota_slots.order(starting_time: :desc).detect { |slot| slot.starting_time < time }
  end
end
