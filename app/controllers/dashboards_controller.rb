class DashboardsController < ApplicationController
  def show
    @dashboard = Dashboard.new(organisations)
  end

  private

  def organisations
    retrieve_organisations.map { |org| OrganisationPresenter.new(org) }
  end

  def retrieve_organisations
    OrganisationFinder.new(api_client).find_all
  end

  def api_client
    DefenceRequestServiceRota.service(:auth_api).new(session[:user_token])
  end
end
