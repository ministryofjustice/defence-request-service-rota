require Rails.root.join("lib/service_registry")

DefenceRequestServiceRota.register_service(:auth_api, FakeDataApi)
