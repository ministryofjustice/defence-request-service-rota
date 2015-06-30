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

  def destroy
    @procurement_area_membership = ProcurementAreaMembership.new(
      procurement_area,
      [],
      membership_params
    )

    @procurement_area_membership.destroy

    redirect_to procurement_area_path(procurement_area)
  end

  private

  def membership_params
    { id: params.delete(:membership_id) }
  end

  def organisations
    Organisation.all
  end

  def procurement_area
    @_procurement_area ||= ProcurementArea.find(params[:procurement_area_id])
  end
end
