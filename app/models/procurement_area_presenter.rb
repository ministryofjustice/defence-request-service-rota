class ProcurementAreaPresenter
  def initialize(procurement_area, api_client)
    @procurement_area = procurement_area
    @api_client = api_client
  end

  def id
    procurement_area.id
  end

  def name
    procurement_area.name
  end

  def memberships
    member_organisations_for_procurement_area
  end

  def locations
    location_organisations_for_procurement_area
  end

  private

  attr_reader :procurement_area, :api_client

  def member_organisations_for_procurement_area
    organisations.select { |org| membership_uids.include? org.uid }
  end

  def membership_uids
    procurement_area.memberships.map { |membership| membership["uid"] }
  end

  def location_organisations_for_procurement_area
    organisations.select { |org| location_uids.include? org.uid }
  end

  def location_uids
    procurement_area.locations.map { |location| location["uid"] }
  end

  def organisations
    api_client.organisations
  end
end
