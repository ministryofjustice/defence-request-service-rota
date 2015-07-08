require "rails_helper"
require "timecop"

RSpec.feature "User views rota" do
  scenario "filtering the rota by date, with the current month as a default" do
    procurement_area = create(
      :procurement_area,
      name: "Gotham"
    )

    custody_suite = create(:organisation,
                           organisation_type: "custody_suite",
                           procurement_area: procurement_area)
    law_firm = create(:organisation,
                      name: "Best Law Firm",
                      organisation_type: "law_firm",
                      procurement_area: procurement_area)

    shift = create(:shift,
                   name: "Normal shift",
                   organisation: custody_suite)

    create(:rota_slot,
           procurement_area: procurement_area,
           starting_time: Time.parse("01/01/2015 09:00"),
           shift: shift,
           organisation_ids: [law_firm.id]
          )

    create(:rota_slot,
           procurement_area: procurement_area,
           starting_time: Time.parse("01/02/2015 09:00"),
           shift: shift,
           organisation_ids: [law_firm.id]
          )

    create(:rota_slot,
           procurement_area: procurement_area,
           starting_time: Time.parse("01/12/2014 09:00"),
           shift: shift,
           organisation_ids: [law_firm.id]
          )

    admin_user = create :admin_user

    Timecop.freeze(2015, 1, 1) do
      login_with admin_user
      visit procurement_area_path procurement_area
      click_link "Manage rotas"

      expect(page).to have_content("Rotas for Gotham")

      expect(page).not_to have_content("Monday, 1 Dec 2014")
      expect(page).to     have_content("Thursday, 1 Jan 2015")
      expect(page).not_to have_content("Sunday, 1 Feb 2015")
      expect(page).to     have_content("Best Law Firm", count: 1)

      select_date Date.parse("01/02/2015"), from: "rota_filter_ending_date"
      click_button "Filter"

      expect(page).not_to have_content("Monday, 1 Dec 2014")
      expect(page).to     have_content("Thursday, 1 Jan 2015")
      expect(page).to     have_content("Sunday, 1 Feb 2015")
      expect(page).to     have_content("Best Law Firm", count: 2)

      select_date Date.parse("01/12/2014"), from: "rota_filter_starting_date"
      select_date Date.parse("01/02/2015"), from: "rota_filter_ending_date"
      click_button "Filter"

      expect(page).to have_content("Monday, 1 Dec 2014")
      expect(page).to have_content("Thursday, 1 Jan 2015")
      expect(page).to have_content("Sunday, 1 Feb 2015")
      expect(page).to have_content("Best Law Firm", count: 3)
    end
  end
end
