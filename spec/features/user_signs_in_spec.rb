require "rails_helper"

RSpec.feature "User signs in" do
  scenario "and is redirected to the dashboard" do
    sign_in_using_dsds_auth

    expect(current_path).to eq "/dashboard"
  end
end
