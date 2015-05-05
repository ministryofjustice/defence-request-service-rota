module DataApiHelpers
  def set_data_api_to(data_api)
    DefenceRequestServiceRota.register_service(:auth_api, data_api)
  end
end
