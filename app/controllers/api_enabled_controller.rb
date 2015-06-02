class ApiEnabledController < ApplicationController
  private

  def api_client
    DefenceRequestServiceRota.service(:auth_api).new(session[:user_token])
  end

  def all_organisations_by(options = {})
    OrganisationFinder.new(api_client, options).find_all
  end

  def find_organisation_by_uid(uid:)
    OrganisationFinder.new(api_client, uid: uid).find
  end
end
