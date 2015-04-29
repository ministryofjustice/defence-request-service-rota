require "rails_helper"

RSpec.feature "User views a list of solicitors" do
  scenario "on their dashboard" do
    admin_user = create :admin_user
    expected_solicitor_names = "Bob Smith", "Andy Brown"

    login_with admin_user

    expect(page).to have_css "h2", text: "Solicitors"
    expect(page).to have_css "h3", text: "Bob Smith"
    expect(page).to have_css "h3", text: "Andy Brown"
  end
end
