class Rota
  attr_reader :procurement_area, :rota_slots, :api_client

  def initialize(rota_slots, procurement_area, api_client)
    @rota_slots = rota_slots
    @procurement_area = procurement_area
    @api_client = api_client
  end

  def to_partial_path
    "rotas/rota"
  end

  def shifts
    rota_slots.map(&:shift).uniq.sort_by(&:name).map { |s| LocationShift.new(s) }
  end

  def locations
    @_locations ||= OrganisationFinder.new(api_client, uids: @procurement_area.locations.map { |l| l.fetch("uid") }).find_all
  end

  def organisations
    @_organisations ||= OrganisationFinder.new(api_client, uids: RotaSlot.for(@procurement_area).map(&:organisation_uid).uniq).find_all
  end

  def location_for_shift(shift)
    locations.detect { |l| l.uid == shift.location_uid }
  end

  def grouped_slots_by_date
    rota_slots.sort_by(&:date).group_by(&:date)
  end

end
