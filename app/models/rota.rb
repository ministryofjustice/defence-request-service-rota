class Rota
  attr_reader :procurement_area, :rota_slots

  def initialize(rota_slots, procurement_area)
    @rota_slots = rota_slots
    @procurement_area = procurement_area
  end

  def to_partial_path
    "rotas/rota"
  end
end
