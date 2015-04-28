class DashboardsController < ApplicationController
  def show
    @dashboard = Dashboard.new(organisations, solicitors)
  end

  private

  def organisations
    Organisation.all
  end

  def solicitors
    Solicitor.all
  end
end
