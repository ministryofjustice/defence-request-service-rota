class DashboardsController < ApplicationController
  def show
    @dashboard = Dashboard.new(data_api)
  end

  private

  def data_api
    DefenceRequestServiceRota.service(:auth_api)
  end
end
