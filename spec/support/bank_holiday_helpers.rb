module BankHolidayHelpers
  def stub_bank_holidays!(contents)
    allow(File).to receive(:exists?).with(Rails.root.join("data", "bank_holidays.ics")).and_return(true)
    allow(File).to receive(:open).with(Rails.root.join("data", "bank_holidays.ics")).and_return(contents)
  end
end
