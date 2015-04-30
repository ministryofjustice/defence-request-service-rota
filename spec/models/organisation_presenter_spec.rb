require_relative "../../app/models/organisation_presenter"

RSpec.describe OrganisationPresenter, "#name" do
  it "returns the presented data api model's name" do
    data_api_model = double(:data_api_model, name: "The Syndicate")

    presenter = OrganisationPresenter.new(data_api_model)

    expect(presenter.name).to eq data_api_model.name
  end
end

RSpec.describe OrganisationPresenter, "#type" do
  it "returns the presented data api model's type" do
    data_api_model = double(:data_api_model, type: "Guild")

    presenter = OrganisationPresenter.new(data_api_model)

    expect(presenter.type).to eq data_api_model.type
  end
end
