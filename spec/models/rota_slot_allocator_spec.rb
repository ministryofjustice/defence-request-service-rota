require "rails_helper"

RSpec.describe RotaSlotAllocator, "#allocate", type: :bank_holidays do
  before :each do
    stub_bank_holidays!(bank_holidays_file)
  end

  it "instantiates the necessary number of rota slots per shift weekday requirement" do
    date_range = Range.new(Date.parse("1/1/2015"), Date.parse("3/1/2015"))
    shifts = [
      build_stubbed(:shift, thursday: 1, starting_time: "09:00"),
      build_stubbed(:shift, friday: 2, starting_time: "11:00", ending_time: "19:00"),
      build_stubbed(:shift, saturday: 1, starting_time: "15:00", ending_time: "15:00")
    ]
    procurement_area = build_stubbed :procurement_area

    allocation = RotaSlotAllocator.new(
      date_range: date_range,
      shifts: shifts,
      procurement_area: procurement_area
    ).allocate

    expect(allocation.map(&:class).uniq).to eq [RotaSlot]
    expect(allocation.length).to eq 3

    expect(allocation[0].starting_time).to            eq Time.parse("1/1/2015 09:00")
    expect(allocation[0].ending_time).to              eq nil
    expect(allocation[0].number_of_firms_required).to eq 1

    expect(allocation[1].starting_time).to            eq Time.parse("2/1/2015 11:00")
    expect(allocation[1].ending_time).to              eq Time.parse("2/1/2015 19:00")
    expect(allocation[1].number_of_firms_required).to eq 2

    expect(allocation[2].starting_time).to            eq Time.parse("3/1/2015 15:00")
    expect(allocation[2].ending_time).to              eq Time.parse("4/1/2015 15:00")
    expect(allocation[2].number_of_firms_required).to eq 1
  end

  it "overrides the allocation for bank holidays on the correct dates " do
    date_range = Range.new(Date.parse("3/1/2015"), Date.parse("5/1/2015"))
    shifts = [
      build_stubbed(:shift, saturday: 1, sunday: 1, monday: 1, bank_holiday: 2, starting_time: "09:00")
    ]
    procurement_area = build_stubbed :procurement_area

    allocation = RotaSlotAllocator.new(
      date_range: date_range,
      shifts: shifts,
      procurement_area: procurement_area
    ).allocate

    expect(allocation.map(&:class).uniq).to eq [RotaSlot]
    expect(allocation.length).to eq 3

    expect(allocation[0].starting_time).to            eq Time.parse("3/1/2015 09:00")
    expect(allocation[0].ending_time).to              eq nil
    expect(allocation[0].number_of_firms_required).to eq 1

    expect(allocation[1].starting_time).to            eq Time.parse("4/1/2015 09:00")
    expect(allocation[1].ending_time).to              eq nil
    expect(allocation[1].number_of_firms_required).to eq 1

    expect(allocation[2].starting_time).to            eq Time.parse("5/1/2015 09:00")
    expect(allocation[2].ending_time).to              eq nil
    expect(allocation[2].number_of_firms_required).to eq 2
  end

  def bank_holidays_file
    <<-FILE.strip_heredoc
      BEGIN:VCALENDAR
      VERSION:2.0
      METHOD:PUBLISH
      PRODID:-//uk.gov/GOVUK calendars//EN
      CALSCALE:GREGORIAN
      BEGIN:VEVENT
      DTEND;VALUE=DATE:20150106
      DTSTART;VALUE=DATE:20150105
      SUMMARY:Stubbed Bank Holiday
      UID:ca6af7456b0088abad9a69f9f620f5ac-0@gov.uk
      SEQUENCE:0
      DTSTAMP:20150617T120853Z
      END:VEVENT
      END:VCALENDAR
    FILE
  end
end
