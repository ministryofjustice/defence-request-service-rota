class ProcurementAreaLocationsController < ApiEnabledController
  def new
    @procurement_area_location = ProcurementAreaLocation.new(
      procurement_area,
      organisations
    )
  end

  def create
    @procurement_area_location = ProcurementAreaLocation.new(
      procurement_area,
      organisations,
      location_params
    )

    if @procurement_area_location.save
      redirect_to procurement_area_path procurement_area
    else
      render :new, error: "Could not add member to procurement_area"
    end
  end

  def destroy
    @procurement_area_location = ProcurementAreaLocation.new(
      procurement_area,
      [],
      { uid: params[:location_uid] }
    )

    @procurement_area_location.destroy

    redirect_to procurement_area_path(procurement_area)
  end

  private

  def location_params
    { uid: params.delete(:location_uid), type: params.delete(:location_type) }
  end

  def organisations
    all_organisations_of_type(types: %w(court custody_suite)).map do |organisation|
      OrganisationPresenter.new(organisation)
    end
  end

  def procurement_area
    @_procurement_area ||= ProcurementArea.find(params[:procurement_area_id])
  end
end
