require "rails_helper"

RSpec.describe AuthService::Strategy, "#with_token" do
  it "returns a strategy prepared with a refreshed oauth2 token" do
    session_token = double(:session_token)
    token_builder = double(:token_builder)
    mock_client = double(:mock_client)
    expected_access_token = double(:mock_access_token)

    allow_any_instance_of(
      OmniAuth::Strategies::DefenceRequest
    ).to receive(:client).and_return(mock_client)

    allow(token_builder).
      to receive(:call).
      with(mock_client, session_token).
      and_return(expected_access_token)

    strategy = AuthService::Strategy.new(session_token, token_builder).with_token

    expect(strategy.access_token).to eq expected_access_token
  end
end
