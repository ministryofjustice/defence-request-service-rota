class ProcurementAreaPresenter
  delegate :id, :name, to: :procurement_area

  def initialize(procurement_area, organisations)
    @procurement_area = procurement_area
    @organisations = organisations
  end

  def memberships
    member_organisations_for_procurement_area
  end

  def locations
    location_organisations_for_procurement_area
  end

  private

  attr_reader :procurement_area, :organisations

  def member_organisations_for_procurement_area
    organisations.select { |org| membership_uids.include? org.uid }
  end

  def membership_uids
    procurement_area.members.map { |membership| membership["uid"] }
  end

  def location_organisations_for_procurement_area
    organisations.select { |org| location_uids.include? org.uid }
  end

  def location_uids
    procurement_area.locations.map { |location| location["uid"] }
  end
end
