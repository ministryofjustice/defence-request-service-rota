class ProcurementAreaLocationsController < ApplicationController
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

  private

  def procurement_area
    ProcurementArea.find(params[:procurement_area_id])
  end

  def organisations
    retrieve_organisations.map { |org| OrganisationPresenter.new(org) }
  end

  def retrieve_organisations
    OrganisationFinder.new(api_client, types: %w(court custody_suite)).find_all
  end

  def api_client
    DefenceRequestServiceRota.service(:auth_api).new(session[:user_token])
  end

  def location_params
    {
      uid: params.delete(:location_uid),
      type: params.delete(:location_type)
    }
  end
end
