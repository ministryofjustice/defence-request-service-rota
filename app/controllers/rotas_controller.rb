class RotasController < ApplicationController
  def index
    @procurement_area = procurement_area
    @rota = Rota.new(rota_slots, organisations, locations)
  end

  def new
    @rota_generation_form = RotaGenerationForm.new(procurement_area)
  end

  def create
    GenerateNewRota.enqueue(params[:rota_generation_form], params[:procurement_area_id], current_user.id)

    redirect_to procurement_area_rotas_path(procurement_area)
  end

  private

  def procurement_area
    ProcurementArea.find(params[:procurement_area_id])
  end

  def filter_date_range
    if params[:rota_filter].present?
      FilterRange.new(params[:rota_filter]).build
    else
      Range.new Time.now.beginning_of_month, Time.now.end_of_month
    end
  end

  def locations
    @procurement_area.locations
  end

  def organisations
    @procurement_area.members
  end

  def rota_slots
    RotaSlot.for(procurement_area).where(starting_time: filter_date_range)
  end
end
