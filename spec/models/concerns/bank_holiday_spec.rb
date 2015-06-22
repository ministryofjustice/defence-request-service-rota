require "rails_helper"

RSpec.describe BankHoliday, type: :bank_holidays do
  before :each do
    stub_bank_holidays!(bank_holidays_file)
  end

  describe "#is_bank_holiday" do
    it "returns true for a date which is in the bank holidays file" do
      expect(Date.new(2012, 1, 2).is_bank_holiday?).to be_truthy
    end

    it "returns false for a date which is not in the bank holidays file" do
      expect(Date.new(2012, 6, 1).is_bank_holiday?).to be_falsey
    end
  end

  def bank_holidays_file
    <<-FILE.strip_heredoc
      BEGIN:VCALENDAR
      VERSION:2.0
      METHOD:PUBLISH
      PRODID:-//uk.gov/GOVUK calendars//EN
      CALSCALE:GREGORIAN
      BEGIN:VEVENT
      DTEND;VALUE=DATE:20120103
      DTSTART;VALUE=DATE:20120102
      SUMMARY:New Year’s Day
      UID:ca6af7456b0088abad9a69f9f620f5ac-0@gov.uk
      SEQUENCE:0
      DTSTAMP:20150617T120853Z
      END:VEVENT
      END:VCALENDAR
    FILE
  end
end
