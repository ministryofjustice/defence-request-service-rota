class Rota
  attr_reader :procurement_area, :rota_slots, :locations, :organisations

  def initialize(rota_slots, procurement_area, locations, organisations)
    @rota_slots = rota_slots
    @procurement_area = procurement_area
    @locations = locations
    @organisations = organisations
  end

  def to_partial_path
    "rotas/rota"
  end
end
