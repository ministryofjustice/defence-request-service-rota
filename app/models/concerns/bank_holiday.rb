module BankHoliday
  include ActiveSupport::Concern

  def is_bank_holiday?
    read_bank_holidays.include?(self)
  end

  private

  def read_bank_holidays
    return [] unless File.exists?(bank_holidays_file)
    Icalendar.parse(File.open(bank_holidays_file)).first.events.map(&:dtstart)
  end

  def bank_holidays_file
    Settings.bank_holidays.file_location
  end
end
