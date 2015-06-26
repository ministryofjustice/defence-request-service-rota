require "rails_helper"

RSpec.feature "User manages procurement areas" do
  background { set_data_api_to FakeDataApis::FakeLawFirmsApi }

  scenario "creating a procurement area" do
    admin_user = create :admin_user

    login_with admin_user
    click_link "Procurement areas"
    click_link "Create procurement area"
    fill_in "Name", with: "Ankh-Morpork"
    click_button "Create Procurement area"

    expect(page).to have_css "h3", text: "Ankh-Morpork"
  end

  scenario "editing a procurement area" do
    admin_user = create :admin_user
    create :procurement_area, name: "Tatooine"

    login_with admin_user
    click_link "Procurement areas"
    click_link "View"
    click_link "Edit"
    fill_in "Name", with: "Monkey Island"
    click_button "Update Procurement area"

    expect(page).to have_css "h3", text: "Monkey Island"
  end

  scenario "deleting a procurement area" do
    admin_user = create :admin_user
    create :procurement_area, name: "Alderaan"

    login_with admin_user
    click_link "Procurement areas"
    click_link "View"
    click_link "Delete"

    expect(page).not_to have_css "h3", text: "Alderaan"
  end

  scenario "viewing a procurement area" do
    admin_user = create :admin_user
    create :procurement_area, name: "The Dig"

    login_with admin_user
    click_link "Procurement areas"
    click_link "View"

    expect(page).to have_css "h2", text: "The Dig"
  end

  scenario "associating a law firm with a procurement area" do
    law_firms_set_by_fake_api = [
      "Guilded Groom & Groom",
      "The Impecably Suited Co."
    ]
    admin_user = create :admin_user
    create :procurement_area, name: "The Dig"

    login_with admin_user
    click_link "Procurement areas"
    click_link "View"
    click_link "Add procurement area member"
    within ".members" do
      click_button "Add", match: :first
    end

    expect(page).to have_content "Guilded Groom & Groom"
  end

  scenario "removing a law firm membership from a procurement area" do
    membership = {
      name: "Guilded Groom & Groom",
      uid: "32252f6a-a6a5-4f52-8ede-58d6127ba231",
      type: "law_firm"
    }
    admin_user = create :admin_user
    create(
      :procurement_area,
      name: "The Dig",
      memberships: [{ uid: membership[:uid], type: "law_firm" }]
    )

    login_with admin_user
    click_link "Procurement areas"
    click_link "View"
    click_link "Delete member"

    expect(page).not_to have_content "Guilded Groom & Groom"
  end

  scenario "associating a location with a procurement area" do
    set_data_api_to FakeDataApis::FakeLocationsApi

    locations_set_by_fake_api = [
      "Brighton Custody Suite",
      "Brighton Magistrates Court"
    ]
    admin_user = create :admin_user
    create :procurement_area, name: "Brighton"

    login_with admin_user
    click_link "Procurement areas"
    click_link "View"
    click_link "Add procurement area member"
    within ".locations" do
      click_button "Add", match: :first
    end

    expect(page).to have_content "Brighton Custody Suite"
  end

  scenario "removing a location from a procurement area" do
    set_data_api_to FakeDataApis::FakeLocationsApi

    location = {
      name: "Brighton Custody Suite",
      uid: "e6256f3b-3920-4e5c-a8e1-5b6277985ca1",
      type: "custody_suite"
    }
    admin_user = create :admin_user
    create :procurement_area, name: "The Dig", memberships: [
      {
        uid: location[:uid],
        type: "custody_suite"
      }
    ]

    login_with admin_user
    click_link "Procurement areas"
    click_link "View"
    within ".locations" do
      click_link "Delete location", match: :first
    end

    expect(page).not_to have_content "Brighton Custody Suite"
  end
end
