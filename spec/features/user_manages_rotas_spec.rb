require "rails_helper"

RSpec.feature "User manages rota" do
  background { set_data_api_to FakeDataApis::FakeLawFirmsApi }

  scenario "for a procurement area" do
    locations = [
      {
        uid: "e6256f3b-3920-4e5c-a8e1-5b6277985ca1",
        name: "Brighton Custody Suite",
        type: "custody_suite",
      },
      {
        uid: "93b8ef50-fe12-4d80-9e7e-05e98232ec13",
        name: "Brighton Magistrates Court",
        type: "court",
      },
    ]
    memberships = [
      {
        uid: "32252f6a-a6a5-4f52-8ede-58d6127ba231",
        name: "Guilded Groom & Groom",
        type: "law_firm",
      },
      {
        uid: "e9001714-2cc0-4cc9-b8a4-e7e1d1368da9",
        name: "The Impecably Suited Co.",
        type: "law_office",
      },
    ]
    procurement_area = create(
      :procurement_area,
      name: "Gotham",
      locations: locations,
      memberships: memberships
    )
    create :shift, name: "Morning Shift", location_uid: locations[0][:uid], monday: 1
    create :shift, name: "Evening Shift", location_uid: locations[0][:uid], tuesday: 1, monday: 1
    admin_user = create :admin_user

    login_with admin_user
    visit procurement_area_path procurement_area
    click_link "Manage rotas"
    click_link "Generate new rota"
    select "2015", from: "rota_generation_form[starting_date(1i)]"
    select "January", from: "rota_generation_form[starting_date(2i)]"
    select "1", from: "rota_generation_form[starting_date(3i)]"
    select "2015", from: "rota_generation_form[ending_date(1i)]"
    select "January", from: "rota_generation_form[ending_date(2i)]"
    select "20", from: "rota_generation_form[ending_date(3i)]"
    click_button "Generate rota"

    expect(page).to have_text "Rota for Gotham"
  end
end
