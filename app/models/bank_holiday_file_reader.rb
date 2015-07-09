class BankHolidayFileReader
  def self.read
    unless File.exists?(bank_holidays_file)
      Rails.logger.error("--- ERROR: --- Tried to access Bank Holiday file which could not be found")
      return []
    end
    Icalendar.parse(File.open(bank_holidays_file)).first.events.map(&:dtstart)
  end

  private

  def self.bank_holidays_file
    Settings.bank_holidays.file_location
  end
end
