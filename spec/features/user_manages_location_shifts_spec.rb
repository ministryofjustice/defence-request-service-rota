require "rails_helper"

RSpec.feature "User manages location shifts" do
  background {
    admin_user = create :admin_user
    login_with admin_user
  }

  scenario "creating a shift" do
    procurement_area = create(:procurement_area)
    create(
      :organisation,
      organisation_type: "custody_suite",
      procurement_area: procurement_area
    )

    visit procurement_area_path(procurement_area)
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
    procurement_area = create(:procurement_area)
    custody_suite = create(
      :organisation,
      organisation_type: "custody_suite",
      procurement_area: procurement_area
    )
    create(
      :shift,
      name: "The Grind",
      organisation: custody_suite,
      starting_time: "06:00"
    )

    visit procurement_area_path(procurement_area)
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
    procurement_area = create(:procurement_area)
    custody_suite = create(
      :organisation,
      organisation_type: "custody_suite",
      procurement_area: procurement_area
    )
    create(
      :shift,
      name: "The Grind",
      organisation: custody_suite,
      starting_time: "06:00"
    )

    visit procurement_area_path procurement_area
    click_link "Manage shifts"
    click_link "Delete shift"

    expect(page).not_to have_content "The Grind"
  end

  scenario "managing day requirements for a shift" do
    procurement_area = create(:procurement_area)
    custody_suite = create(
      :organisation,
      organisation_type: "custody_suite",
      procurement_area: procurement_area
    )
    shift = create(
      :shift,
      name: "Late shift",
      organisation: custody_suite,
      starting_time: "08:00",
      ending_time: "16:00"
    )

    visit location_shift_path(shift, organisation_id: custody_suite.id)
    click_link "Manage daily requirements for shift"
    fill_in "shift_monday", with: 1
    fill_in "shift_thursday", with: 3
    fill_in "shift_saturday", with: 2
    fill_in "shift_bank_holiday", with: 5
    click_button "Update requirements"

    expect(
      page_displays_allocation_per_day_of_the_week(
        monday: 1,
        thursday: 3,
        saturday: 2,
        sunday: 0,
        bank_holiday: 5
      )
    ).to eq true
  end

  def page_displays_allocation_per_day_of_the_week(allocation_hash)
    allocation_hash.inject(true) do |result, (weekday, allocation)|
      weekday_index = all("th").map(&:text).find_index weekday.to_s.humanize
      result = all("td")[weekday_index].text == allocation.to_s

      unless result
        raise RSpec::Expectations::ExpectationNotMetError.new(
          "Expected an allocation of #{allocation} for #{weekday.capitalize}"
        )
      end

      result
    end
  end
end
