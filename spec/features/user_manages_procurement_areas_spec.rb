require "rails_helper"

RSpec.feature "User manages procurement areas" do
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
    click_link "Delete"

    expect(page).not_to have_css "h3", text: "Alderaan"
  end
end
