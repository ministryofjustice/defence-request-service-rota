class RotaGenerationForm
  include ActiveModel::Model

  attr_accessor :starting_date, :ending_date

  def initialize(procurement_area, attrs = {})
    @procurement_area = procurement_area
    @attrs = attrs
  end

  def procurement_area_id
    @procurement_area.id
  end
end
