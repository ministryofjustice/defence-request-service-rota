require "rails_helper"

RSpec.feature "User manages organisations" do
  background do
    login_with create(:admin_user)
  end

  scenario "creating an organisation" do
    click_link "Organisations"
    click_link "Create organisation"
    fill_in "Name", with: "Expert Lawyers 4U"
    select "Law firm", from: "Organisation type"
    click_button "Create Organisation"

    expect(page).to have_css "h3", text: "Expert Lawyers 4U"
  end

  scenario "editing an organisation" do
    create(:organisation,
           name: "Expert Lawyers 4U",
           organisation_type: "law_firm")

    click_link "Organisations"
    click_link "View"
    click_link "Edit"
    fill_in "Name", with: "Rubbish Lawyers 4U"
    click_button "Update Organisation"

    expect(page).to have_css "h3", text: "Rubbish Lawyers 4U"
  end

  scenario "deleting an organisation" do
    create(:organisation,
           name: "Expert Lawyers 4U",
           organisation_type: "law_firm")

    click_link "Organisations"
    click_link "View"
    click_link "Delete"

    expect(page).not_to have_css "h3", text: "Rubbish Lawyers 4U"
  end

  scenario "viewing an organisation" do
    create(:organisation,
           name: "Expert Lawyers 4U",
           organisation_type: "law_firm",
           tel: "01234567890",
           mobile: "07234567890",
           email: "expert@lawyers4u.com",
           address: "123 Law Lane",
           postcode: "L4W L4W")

    click_link "Organisations"
    click_link "View"

    expect(page).to have_css "h2", text: "Expert Lawyers 4U"
    expect(page).to have_content("Law firm")
    expect(page).to have_content("01234567890")
    expect(page).to have_content("07234567890")
    expect(page).to have_content("expert@lawyers4u.com")
    expect(page).to have_content("123 Law Lane")
    expect(page).to have_content("L4W L4W")
  end
end
