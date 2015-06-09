class ProcurementAreaMembership
  delegate :id, :name, to: :procurement_area

  def initialize(procurement_area, organisations, membership_params = {})
    @procurement_area = procurement_area
    @organisations = organisations
    @membership_params = membership_params
  end

  def eligible_members
    organisations.
      select { |org| ProcurementArea::MEMBER_TYPES.include?(org.type) }.
      reject { |org| procurement_area.members.any? { |member| member["uid"] == org.uid } }
  end

  def eligible_locations
    organisations.
      select { |org| ProcurementArea::LOCATION_TYPES.include?(org.type) }.
      reject { |org| procurement_area.locations.any? { |location| location["uid"] == org.uid } }
  end

  def save
    if valid?
      add_membership_to_procurement_area
      save_procurement_area!
    else
      false
    end
  end

  def destroy
    procurement_area.destroy_membership!(membership_params[:uid])
  end

  private

  attr_reader :membership_params, :procurement_area, :organisations

  def valid?
    membership_params_are_present? &&
      membership_uid_is_present? &&
      membership_type_is_present?
  end

  def membership_params_are_present?
    membership_params
  end

  def membership_uid_is_present?
    membership_params[:uid] != nil && !membership_params[:uid].empty?
  end

  def membership_type_is_present?
    membership_params[:type] != nil && !membership_params[:type].empty?
  end

  def add_membership_to_procurement_area
    procurement_area.memberships.push(
      uid: membership_params.fetch(:uid),
      type: membership_params.fetch(:type)
    )
  end

  def save_procurement_area!
    procurement_area.save!
  end
end
