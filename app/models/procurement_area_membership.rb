class ProcurementAreaMembership
  delegate :id, :name, to: :procurement_area

  def initialize(procurement_area, organisations, membership_params = {})
    @procurement_area = procurement_area
    @organisations = organisations
    @membership_params = membership_params
  end

  def members
    organisations.members
  end

  def eligible_members
    members.where(procurement_area_id: nil)
  end

  def current_members
    procurement_area.members
  end

  def locations
    organisations.locations
  end

  def eligible_locations
    locations.where(procurement_area_id: nil)
  end

  def current_locations
    procurement_area.locations
  end

  def save
    if valid?
      add_membership
    else
      false
    end
  end

  def destroy
    destroy_membership
  end

  private

  attr_reader :membership_params, :procurement_area, :organisations

  def valid?
    membership_params_are_present? &&
      membership_uid_is_present?
  end

  def membership_params_are_present?
    membership_params
  end

  def membership_uid_is_present?
    membership_params[:id] != nil
  end

  def add_membership
    organisation.update_attributes(
      procurement_area: procurement_area
    )
  end

  def destroy_membership
    organisation.update_attributes(
      procurement_area: nil
    )
  end

  def organisation
    Organisation.find(membership_params[:id])
  end
end
