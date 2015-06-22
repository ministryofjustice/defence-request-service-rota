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
    slots = slots_with_on_duty_shift
    return nil if slots.empty?

    slot = slot_with_least_requests(slots)
    slot.update_request_count!
    slot.organisation_uid
  end

  def slots_with_on_duty_shift
    slot = find_latest_slot

    if slot_on_duty_now?(slot)
      rota_slots.select do |s|
        s.starting_time == slot.starting_time && s.shift_id == slot.shift_id
      end
    else
      []
    end
  end

  def find_latest_slot
    rota_slots.detect { |slot| slot.starting_time <= time }
  end

  def slot_with_least_requests(slots)
    slots.sort_by(&:request_count).first
  end

  def slot_on_duty_now?(slot)
    if slot.nil?
      return false
    elsif slot.ending_time.present? && slot.ending_time < time
      return false
    end
    true
  end
end
