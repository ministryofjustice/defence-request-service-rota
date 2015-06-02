class ProcurementAreaPresenter < SimpleDelegator
  def initialize(procurement_area, organisations)
    super(procurement_area)
    @organisations = organisations
  end

  def memberships
    @organisations.select { |org| ProcurementArea::MEMBER_TYPES.include? org.type }
  end

  def locations
    @organisations.select { |org| ProcurementArea::LOCATION_TYPES.include? org.type }
  end
end
