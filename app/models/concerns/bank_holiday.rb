module BankHoliday
  include ActiveSupport::Concern

  def is_bank_holiday?
    read_bank_holidays.include?(self)
  end

  private

  def read_bank_holidays
    Icalendar.parse(File.open(bank_holidays_file)).first.events.map(&:dtstart)
  end

  def bank_holidays_file
    Rails.root.join("public", "england-and-wales.ics")
  end
end
