class OrganisationFinder
  def initialize(api_client, options = {})
    @api_client = api_client
    @options = options
  end

  def find_all
    api_client.organisations(options)
  end

  private

  attr_reader :api_client, :options
end
