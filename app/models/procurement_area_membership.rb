class ProcurementAreaMembership
  def initialize(procurement_area, organisations, membership_params = {})
    @procurement_area = procurement_area
    @organisations = organisations
    @membership_params = membership_params
  end

  def area_name
    procurement_area.name
  end

  def area_id
    procurement_area.id
  end

  def eligible_organisations
    filter_organisations
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
