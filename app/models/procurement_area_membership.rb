class ProcurementAreaMembership
  delegate :id, :name, to: :procurement_area

  def initialize(procurement_area, organisations, membership_params = {})
    @procurement_area = procurement_area
    @organisations = organisations
    @membership_params = membership_params
  end

  def eligible_members
    eligible_organisations[0]
  end

  def eligible_locations
    eligible_organisations[1]
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

  def eligible_organisations
    filter_organisations.partition { |org| ProcurementArea::MEMBER_TYPES.any? { |type| type == org.type } }
  end

  def filter_organisations
    organisations.reject do |org|
      procurement_area.memberships.flat_map(&:values).include? org.uid
    end
  end

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
