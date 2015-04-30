class OrganisationPresenter
  def initialize(data_api_model)
    @data_api_model = data_api_model
  end

  def name
    data_api_model.name
  end

  def type
    data_api_model.type
  end

  def to_partial_path
    "organisations/organisation"
  end

  private

  attr_reader :data_api_model
end
