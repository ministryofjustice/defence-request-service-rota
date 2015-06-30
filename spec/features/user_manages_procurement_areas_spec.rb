require "rails_helper"

RSpec.feature "User manages procurement areas" do
  background do
    login_with create(:admin_user)
  end

  scenario "creating a procurement area" do
    click_link "Procurement areas"
    click_link "Create procurement area"
    fill_in "Name", with: "Ankh-Morpork"
    click_button "Create Procurement area"

    expect(page).to have_css "h3", text: "Ankh-Morpork"
  end

  scenario "editing a procurement area" do
    create(:procurement_area, name: "Tatooine")

    click_link "Procurement areas"
    click_link "View"
    click_link "Edit"
    fill_in "Name", with: "Monkey Island"
    click_button "Update Procurement area"

    expect(page).to have_css "h3", text: "Monkey Island"
  end

  scenario "deleting a procurement area" do
    create(:procurement_area, name: "Alderaan")

    click_link "Procurement areas"
    click_link "View"
    click_link "Delete"

    expect(page).not_to have_css "h3", text: "Alderaan"
  end

  scenario "viewing a procurement area" do
    create(:procurement_area, name: "The Dig")

    click_link "Procurement areas"
    click_link "View"

    expect(page).to have_css "h2", text: "The Dig"
  end

  scenario "associating a law firm with a procurement area" do
    create(:procurement_area, name: "The Dig")
    create(:organisation,
           organisation_type: "law_firm",
           name: "Guilded Groom & Groom")

    click_link "Procurement areas"
    click_link "View"
    click_link "Add procurement area member"
    within ".members" do
      click_button "Add", match: :first
    end

    expect(page).to have_content "Guilded Groom & Groom"
  end

  scenario "removing a law firm membership from a procurement area" do
    procurement_area = create(:procurement_area, name: "The Dig")
    create(:organisation,
           organisation_type: "law_firm",
           name: "Guilded Groom & Groom",
           procurement_area: procurement_area)

    click_link "Procurement areas"
    click_link "View"
    click_link "Delete member"

    expect(page).not_to have_content "Guilded Groom & Groom"
  end

  scenario "associating a location with a procurement area" do
    create(:procurement_area, name: "Brighton")
    create(:organisation,
           organisation_type: "custody_suite",
           name: "Brighton Custody Suite")

    click_link "Procurement areas"
    click_link "View"
    click_link "Add procurement area member"
    within ".locations" do
      click_button "Add", match: :first
    end

    expect(page).to have_content "Brighton Custody Suite"
  end

  scenario "removing a location from a procurement area" do
    procurement_area = create(:procurement_area, name: "The Dig")
    create(:organisation,
           organisation_type: "custody_suite",
           name: "Brighton Custody Suite",
           procurement_area: procurement_area)

    click_link "Procurement areas"
    click_link "View"
    within ".locations" do
      click_link "Delete location", match: :first
    end

    expect(page).not_to have_content "Brighton Custody Suite"
  end
end
