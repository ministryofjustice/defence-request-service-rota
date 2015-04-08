require "rails_helper"

RSpec.feature "User views a list of solicitors" do
  def sign_in_using_dsds_auth
    visit root_path
  end

  scenario "on their dashboard" do
    expected_solicitor_names = "Bob Smith", "Andy Brown"

    mock_token
    mock_profile

    sign_in_using_dsds_auth

    expect(page).to have_css "h3", text: "Bob Smith"
    expect(page).to have_css "h3", text: "Andy Brown"
  end
end
