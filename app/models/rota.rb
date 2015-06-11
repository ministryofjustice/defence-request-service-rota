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
      (sorted_slots.first.date..sorted_slots.last.date)
    else
      []
    end
  end

  def organisations_for(date, shift)
    organisation_uids = rota_slots.where(date: date, shift_id: shift.id).map(&:organisation_uid)

    organisations_with_uids(organisation_uids)
  end

  def procurement_area_name
    rota_slots.first.procurement_area.name if !rota_slots.empty?
  end

  def shifts
    sorted_shifts.map { |shift| ShiftPresenter.new(shift) }
  end

  def location_for_shift(shift)
    locations.detect { |l| l.uid == shift.location_uid }
  end

  def organisations_with_uids(uids)
    uids.map { |uid| organisations.detect { |o| o.uid == uid } }
  end

  def sorted_slots
    rota_slots.sort_by(&:date)
  end

  def sorted_shifts
    rota_slots.map(&:shift).uniq.sort_by(&:name)
  end
end
