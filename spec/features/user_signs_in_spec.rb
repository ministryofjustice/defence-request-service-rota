require "rails_helper"

RSpec.feature "User signs in" do
  scenario "and is redirected to the dashboard" do
    admin_user = create :admin_user
    login_with admin_user

    expect(current_path).to eq "/dashboard"
  end

  scenario "with no roles for Rota app gets redirected to auth failure page" do
    admin_user = create :admin_user
    unauthorized_login_with admin_user

    expect(current_path).to eq "/auth/failure"
  end

  scenario "has a sign out link when logged in" do
    admin_user = create :admin_user
    login_with admin_user
    expect(page).to have_link("Sign out", "/users/sign_out")
  end
end
