class ProcurementAreaRotasController < ApplicationController
  def index
    @procurement_area = procurement_area
  end

  def new
    @rota_generation_form = RotaGenerationForm.new(procurement_area)
  end

  def create
    allocated_rota_slots
    organisations
  end

  private

  def procurement_area
    ProcurementArea.find(params[:procurement_area_id])
  end

  def allocated_rota_slots
    RotaSlotAllocator.new(date_range: build_date_range, shifts: shifts_for_location).allocate
  end

  def build_date_range
    DateRange.new(params[:rota_generation_form]).build
  end

  def shifts_for_location
    Shift.for procurement_area.locations.flat_map { |location| location["uid"] }
  end

  def organisations
    procurement_area.memberships.flat_map { |membership| membership["uid"] }
  end
end
