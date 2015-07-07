require "rails_helper"

RSpec.feature "User manages rota" do
  let(:admin_user) { create :admin_user, name: "Rota Expert" }

  background do
    login_with admin_user
  end

  scenario "generating a new rota for a procurement area" do
    procurement_area = create(
      :procurement_area,
      name: "Gotham"
    )
    custody_suite = create(:organisation,
                           organisation_type: "custody_suite",
                           procurement_area: procurement_area)
    create(:organisation,
           name: "Best Law Firm",
           organisation_type: "law_firm",
           procurement_area: procurement_area)

    create :shift, name: "Morning Shift", organisation: custody_suite, monday: 1, tuesday: 1
    visit procurement_area_path procurement_area
    click_link "Manage rotas"
    click_link "Generate new rota"
    select_date Date.parse("05/01/2015"), from: "rota_generation_form_starting_date"
    select_date Date.parse("06/01/2015"), from: "rota_generation_form_ending_date"
    click_button "Generate rota"

    wait_to_ensure_generation_has_finished

    expect(page).to have_text "Rotas for Gotham"

    select_date Date.parse("01/01/2015"), from: "rota_filter_starting_date"
    select_date Date.parse("31/01/2015"), from: "rota_filter_ending_date"
    click_button "Filter"

    expect(page).to have_content "Monday, 5 Jan 2015"
    expect(page).to have_content "Tuesday, 6 Jan 2015"
    expect(page).to have_content "Best Law Firm", count: 2
  end

  scenario "showing the results of previous runs when generating a new rota" do
    procurement_area = create(
      :procurement_area,
      name: "Gotham"
    )

    create(
      :rota_generation_log_entry,
      procurement_area: procurement_area,
      user: admin_user,
      total_slots: 400,
      start_time: Time.parse("01/01/2015 09:00"),
      end_time: Time.parse("01/01/2015 09:15:45")
    )

    create(
      :rota_generation_log_entry,
      :failed,
      procurement_area: procurement_area,
      user: create(:admin_user, name: "Rota Novice"),
      total_slots: 8000,
      start_time: Time.parse("05/01/2015 17:00"),
      end_time: Time.parse("05/01/2015 17:26:12")
    )

    visit procurement_area_path procurement_area
    click_link "Manage rotas"
    click_link "Generate new rota"

    expect(page).to have_content "Thursday, 1 Jan 2015, 09:00"
    expect(page).to have_content "15m 45s"
    expect(page).to have_content "Successful"
    expect(page).to have_content "400 slots"
    expect(page).to have_content "Rota Expert"

    expect(page).to have_content "Monday, 5 Jan 2015, 17:00"
    expect(page).to have_content "26m 12s"
    expect(page).to have_content "Failed"
    expect(page).to have_content "8000 slots"
    expect(page).to have_content "Rota Novice"
  end

  def wait_to_ensure_generation_has_finished
    sleep(2)
  end
end
