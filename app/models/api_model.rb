class APIModel
  private

  def self.data_api
    DefenceRequestServiceRota.service(:auth_api)
  end
end
