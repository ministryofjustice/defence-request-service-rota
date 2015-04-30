require Rails.root.join("lib/service_registry")

Drs::AuthClient.configure do |client|
  client.host = ENV.fetch("AUTHENTICATION_SITE_URL")
  client.version = :v1
end

DefenceRequestServiceRota.register_service(:auth_api, Drs::AuthClient::Client)
