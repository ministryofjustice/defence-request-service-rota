require "rails_helper"

RSpec.feature "User views a list of organisations" do
  background { set_data_api_to FakeDataApi }

  scenario "on their dashboard" do
    admin_user = create :admin_user
    expected_organisation_names = "Tuckers", "Brighton"

    login_with admin_user

    expect(page).to have_css "h2", text: "Organisations"
    expect(page).to have_css "h3", text: "Tuckers (law_firm)"
    expect(page).to have_css "h3", text: "Brighton (custody_suite)"
  end
end
