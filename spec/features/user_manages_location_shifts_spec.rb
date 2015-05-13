require "rails_helper"

RSpec.feature "User manages location shifts" do
  background { set_data_api_to FakeDataApis::FakeLocationsApi }

  scenario "creating a shift" do
    locations = [
      {
        uid: "2345678901bcdefa",
        type: "custody_suite"
      }
    ]
    procurement_area = create(
      :procurement_area,
      name: "Tatooine",
      locations: locations
    )
    admin_user = create :admin_user
    login_with admin_user

    visit procurement_area_path procurement_area
    click_link "Manage shifts"
    click_link "Add shift"
    fill_in "Name", with: "Morning shift"
    select "08", from: "location_shift_form_starting_time_4i"
    select "00", from: "location_shift_form_starting_time_5i"
    select "20", from: "location_shift_form_ending_time_4i"
    select "00", from: "location_shift_form_ending_time_5i"
    click_button "Create shift"

    expect(page).to have_content "Morning shift - 08:00 / 20:00"
  end

  scenario "editing a shift" do
    locations = [
      {
        uid: "2345678901bcdefa",
        type: "custody_suite"
      }
    ]
    procurement_area = create(
      :procurement_area,
      name: "Tatooine",
      locations: locations
    )
    create(
      :shift,
      name: "The Grind",
      location_uid: locations.first[:uid],
      starting_time: "06:00"
    )
    admin_user = create :admin_user
    login_with admin_user

    visit procurement_area_path procurement_area
    click_link "Manage shifts"
    click_link "Edit shift"
    fill_in "Name", with: "No longer the Grind"
    select "10", from: "shift_starting_time_4i"
    select "00", from: "shift_starting_time_5i"
    select "11", from: "shift_ending_time_4i"
    select "30", from: "shift_ending_time_5i"
    click_button "Update shift"

    expect(page).to have_content "No longer the Grind - 10:00 / 11:30"
  end

  scenario "deleting a shift" do
    locations = [
      {
        uid: "2345678901bcdefa",
        type: "custody_suite"
      }
    ]
    procurement_area = create(
      :procurement_area,
      name: "Tatooine",
      locations: locations
    )
    create(
      :shift,
      name: "The Grind",
      location_uid: locations.first[:uid],
      starting_time: "06:00"
    )
    admin_user = create :admin_user
    login_with admin_user

    visit procurement_area_path procurement_area
    click_link "Manage shifts"
    click_link "Delete shift"

    expect(page).not_to have_content "The Grind"
  end
end
