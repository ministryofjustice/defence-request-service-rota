require "rails_helper"

RSpec.feature "User signs in" do
  def sign_in_using_dsds_auth
    visit root_path
  end

  scenario "and is redirected to the dashboard" do
    mock_token
    mock_profile

    sign_in_using_dsds_auth

    expect(current_path).to eq "/dashboard"
  end
end
