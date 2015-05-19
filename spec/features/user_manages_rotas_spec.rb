require "rails_helper"

RSpec.feature "User manages rota" do
  background { set_data_api_to FakeDataApis::FakeLawFirmsApi }

  scenario "for a procurement area" do
    location = { uid: "2345678901bcdefa", type: "custody_suite" }
    admin_user = create :admin_user
    procurement_area = create :procurement_area, name: "Gotham", locations: [location]
    create :shift, location_uid: location[:uid]

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

    expect(page).to have_text "Rota for Gotham - January 1st to January 20th 2015"
  end
end
