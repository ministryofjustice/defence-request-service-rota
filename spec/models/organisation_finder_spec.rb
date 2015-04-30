require_relative "../../app/models/organisation_finder"

RSpec.describe OrganisationFinder, "#find_all" do
  it "queries the data api for a full list of organisations" do
    data_api_client = spy(:data_api_client)

    OrganisationFinder.new(data_api_client).find_all

    expect(data_api_client).to have_received(:organisations)
  end
end
