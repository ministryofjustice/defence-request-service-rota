class Dashboard
  attr_reader :data_api

  def initialize(data_api)
    @data_api = data_api
  end

  def solicitors
    data_api.solicitors[:profiles].map { |attrs| Solicitor.build_from(attrs) }
  end
end
