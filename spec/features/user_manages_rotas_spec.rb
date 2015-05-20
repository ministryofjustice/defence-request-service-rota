require "rails_helper"

RSpec.feature "User manages rota" do
  background { set_data_api_to FakeDataApis::FakeLawFirmsApi }

  scenario "for a procurement area" do
    locations = [
      {
        name: "Custody Suite",
        uid: "33432f6a-a6a5-4f52-8ede-58d6127ba232"
      },
      {
        name: "Court",
        uid: "34452f6a-a6a5-4f52-8ede-58d6127ba232"
      },
    ]
    memberships = [
      {
        name: "Guilded Groom & Groom",
        uid: "32252f6a-a6a5-4f52-8ede-58d6127ba231"
      },
      {
        name: "The Impecably Suited Co.",
        uid: "32252f6a-a6a5-4f52-8ede-58d6127ba232"
      },
    ]
    procurement_area = create(
      :procurement_area,
      name: "Gotham",
      locations: locations,
      memberships: memberships
    )
    create :shift, location_uid: locations[0][:uid], monday: 1
    create :shift, location_uid: locations[0][:uid], tuesday: 1, monday: 1
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
    save_and_open_page

    expect(page).to have_text "Rota for Gotham"
  end
end
