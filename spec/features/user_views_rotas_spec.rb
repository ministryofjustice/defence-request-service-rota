require "rails_helper"
require "timecop"

RSpec.feature "User views rota" do
  background { set_data_api_to FakeDataApis::FullDataStore }

  scenario "filtering the rota by date, with the current month as a default" do
    procurement_area = create(
      :procurement_area,
      name: "Gotham",
      memberships: [
        {
          uid: "e6256f3b-3920-4e5c-a8e1-5b6277985ca1",
          name: "Brighton Custody Suite",
          type: "custody_suite",
        },
        {
          uid: "32252f6a-a6a5-4f52-8ede-58d6127ba231",
          name: "Guilded Groom & Groom",
          type: "law_firm",
        }
      ]
    )

    shift = create(:shift,
                   name: "Normal shift",
                   location_uid: "e6256f3b-3920-4e5c-a8e1-5b6277985ca1")

    create(:rota_slot,
           procurement_area: procurement_area,
           starting_time: Time.parse("01/01/2015 09:00"),
           shift: shift,
           organisation_uid: "32252f6a-a6a5-4f52-8ede-58d6127ba231"
          )

    create(:rota_slot,
           procurement_area: procurement_area,
           starting_time: Time.parse("01/02/2015 09:00"),
           shift: shift,
           organisation_uid: "32252f6a-a6a5-4f52-8ede-58d6127ba231"
          )

    create(:rota_slot,
           procurement_area: procurement_area,
           starting_time: Time.parse("01/12/2014 09:00"),
           shift: shift,
           organisation_uid: "32252f6a-a6a5-4f52-8ede-58d6127ba231"
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

      select_date Date.parse("01/02/2015"), from: "rota_filter_ending_date"
      click_button "Filter"

      expect(page).not_to have_content("Monday, 1 Dec 2014")
      expect(page).to     have_content("Thursday, 1 Jan 2015")
      expect(page).to     have_content("Sunday, 1 Feb 2015")

      select_date Date.parse("01/12/2014"), from: "rota_filter_starting_date"
      select_date Date.parse("01/02/2015"), from: "rota_filter_ending_date"
      click_button "Filter"

      expect(page).to have_content("Monday, 1 Dec 2014")
      expect(page).to have_content("Thursday, 1 Jan 2015")
      expect(page).to have_content("Sunday, 1 Feb 2015")
    end
  end
end
