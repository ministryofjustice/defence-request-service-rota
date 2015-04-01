require "spec_helper"
require "omniauth-oauth2"
require_relative "../../../app/services/auth_service/token_builder"

RSpec.describe AuthService::TokenBuilder, "#call" do
  it "creates a new oauth2 access token from a client and existing token" do
    client = double(:client)
    access_token = "token_string"

    token = AuthService::TokenBuilder.new.call(client, access_token)

    expect(token.client).to eq client
    expect(token.token).to eq access_token
  end
end
