require_relative "../../lib/rota_generation"

class ProcurementAreaRotasController < ApplicationController
  def index
    @procurement_area = procurement_area
    @rota = Rota.new(RotaSlot.for(procurement_area), procurement_area, api_client)
  end

  def new
    @rota_generation_form = RotaGenerationForm.new(procurement_area)
  end

  def create
    assigned_rota_slots = RotaGeneration::Generator.new(
      allocated_rota_slots,
      organisations
    ).generate_rota

    if assigned_rota_slots.map(&:save!)
      redirect_to procurement_area_rotas_path(procurement_area_id: procurement_area.id)
    end
  end

  private

  def procurement_area
    ProcurementArea.find(params[:procurement_area_id])
  end

  def allocated_rota_slots
    RotaSlotAllocator.new(
      date_range: build_date_range,
      shifts: shifts_for_location,
      procurement_area: procurement_area
    ).allocate
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

  def api_client
    DefenceRequestServiceRota.service(:auth_api).new(session[:user_token])
  end
end
