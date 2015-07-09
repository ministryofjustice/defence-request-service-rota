module BankHoliday
  include ActiveSupport::Concern

  def is_bank_holiday?
    read_bank_holidays.include?(self)
  end

  private

  def read_bank_holidays
    BankHolidayFileReader.read
  end

end
