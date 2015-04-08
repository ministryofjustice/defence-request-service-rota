class APIModel
  class << self
    private

    def data_api
      DefenceRequestServiceRota.service(:auth_api)
    end
  end
end
