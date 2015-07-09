class Rota
  attr_reader :rota_slots, :organisations, :locations

  def initialize(rota_slots, organisations, locations)
    @rota_slots = rota_slots
    @organisations = organisations
    @locations = locations
  end

  def to_partial_path
    "rotas/rota"
  end

  def date_range
    if !rota_slots.empty?
      (sorted_slots.first.starting_time.to_date..sorted_slots.last.starting_time.to_date)
    else
      []
    end
  end

  def on_duty(date, shift)
    organisations_and_solicitor_names(slot_on_duty(date, shift))
  end

  def procurement_area_name
    rota_slots.first.procurement_area.name if !rota_slots.empty?
  end

  def shifts
    sorted_shifts.map { |shift| ShiftPresenter.new(shift) }
  end

  def location_for_shift(shift)
    shift.organisation
  end

  def sorted_slots
    rota_slots.sort_by(&:starting_time)
  end

  def sorted_shifts
    rota_slots.map(&:shift).uniq.sort_by(&:name)
  end

  private

  def slot_on_duty(date, shift)
    rota_slots.select { |s| s.starting_time.to_date == date && s.shift_id == shift.id }
  end

  def organisations_and_solicitor_names(slots)
    slots.map do |slot|
      slot.organisation_ids.map do |org_id|
        {
          organisation_name: Organisation.find(org_id).name,
          organisation_id: org_id
        }
      end
    end
  end

end
