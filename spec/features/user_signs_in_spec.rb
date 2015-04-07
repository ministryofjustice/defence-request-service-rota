require "rails_helper"

RSpec.feature "User signs in" do
  scenario "and is redirected to the dashboard" do
    Features::OmniauthSignInHelper.mock_token
    Features::OmniauthSignInHelper.mock_profile

    sign_in_using_dsds_auth

    expect(current_path).to eq "/dashboard"
  end
end
