class ProcurementAreaMembershipsController < ApiEnabledController
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
      { uid: params[:membership_uid] }
    )

    @procurement_area_membership.destroy

    redirect_to procurement_area_path(procurement_area)
  end

  private

  def membership_params
    { uid: params.delete(:membership_uid), type: params.delete(:membership_type) }
  end

  def organisations
    all_organisations_of_type(types: %w(law_firm law_office court custody_suite)).map do |organisation|
      OrganisationPresenter.new(organisation)
    end
  end

  def procurement_area
    @_procurement_area ||= ProcurementArea.find(params[:procurement_area_id])
  end
end
