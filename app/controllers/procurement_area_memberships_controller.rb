class ProcurementAreaMembershipsController < ApplicationController
  def new
    @procurement_area_membership = ProcurementAreaMembership.new(
      procurement_area,
      organisations
    )
  end

  def create
    @procurement_area_membership = ProcurementAreaMembership.new(
      procurement_area,
      organisations,
      membership_params
    )

    if @procurement_area_membership.save
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
    OrganisationFinder.new(api_client, types: %w(law_firm law_office)).find_all
  end

  def api_client
    DefenceRequestServiceRota.service(:auth_api).new(session[:user_token])
  end

  def membership_params
    {
      uid: params.delete(:membership_uid),
      type: params.delete(:membership_type)
    }
  end
end
