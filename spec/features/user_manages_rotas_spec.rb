require "rails_helper"

RSpec.feature "User manages rota" do
  background {
    admin_user = create :admin_user

    login_with admin_user
  }

  scenario "for a procurement area" do
    procurement_area = create(
      :procurement_area,
      name: "Gotham"
    )
    custody_suite = create(:organisation,
                           organisation_type: "custody_suite",
                           procurement_area: procurement_area)
    court = create(:organisation,
                   organisation_type: "court",
                   procurement_area: procurement_area)
    create(:organisation,
           organisation_type: "law_firm",
           procurement_area: procurement_area)

    create :shift, name: "Morning Shift", organisation: custody_suite, monday: 1
    create :shift, name: "Evening Shift", organisation: court, tuesday: 1, monday: 1
    visit procurement_area_path procurement_area
    click_link "Manage rotas"
    click_link "Generate new rota"
    select_date Date.parse("01/01/2015"), from: "rota_generation_form_starting_date"
    select_date Date.parse("20/01/2015"), from: "rota_generation_form_ending_date"
    click_button "Generate rota"

    expect(page).to have_text "Rotas for Gotham"
  end
end
