class OrganisationFinder
  def initialize(api_client)
    @api_client = api_client
  end

  def find_all
    api_client.organisations
  end

  private

  attr_reader :api_client
end
