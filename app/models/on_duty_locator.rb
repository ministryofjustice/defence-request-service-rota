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

  def slot_with_on_duty_shift
    rota_slots.detect { |slot| slot.shift.starting_time < time }
  end

  def on_duty_organisation_uid
    slot_with_on_duty_shift.organisation_uid
  end
end
