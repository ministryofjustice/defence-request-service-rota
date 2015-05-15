class OrganisationPresenter
  def initialize(data_api_model)
    @data_api_model = data_api_model
  end

  def uid
    data_api_model.uid
  end

  def name
    data_api_model.name
  end

  def type
    data_api_model.type
  end

  def supplier_number
    OrganisationDetail.where(organisation_uid: uid).first.try(:supplier_number)
  end

  private

  attr_reader :data_api_model
end
