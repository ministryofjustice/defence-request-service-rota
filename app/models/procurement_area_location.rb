class ProcurementAreaLocation
  def initialize(procurement_area, organisations, location_params = {})
    @procurement_area = procurement_area
    @organisations = organisations
    @location_params = location_params
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
      add_location_to_procurement_area
      save_procurement_area
    else
      false
    end
  end

  private

  attr_reader :location_params, :procurement_area, :organisations

  def filter_organisations
    organisations.reject do |org|
      procurement_area.locations.flat_map(&:values).include? org.uid
    end
  end

  def valid?
    location_params_are_present? &&
      location_uid_is_present? &&
      location_type_is_present?
  end

  def location_params_are_present?
    location_params
  end

  def location_uid_is_present?
    location_params[:uid] != nil && !location_params[:uid].empty?
  end

  def location_type_is_present?
    location_params[:type] != nil && !location_params[:type].empty?
  end

  def add_location_to_procurement_area
    procurement_area.locations.push(
      uid: location_params.fetch(:uid),
      type: location_params.fetch(:type)
    )
  end

  def save_procurement_area
    procurement_area.save!
  end
end
