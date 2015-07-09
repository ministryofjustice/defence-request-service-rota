module BankHolidayHelpers
  def stub_bank_holidays!(dates)
    allow(BankHolidayFileReader).to receive(:read).and_return(dates)
  end
end
