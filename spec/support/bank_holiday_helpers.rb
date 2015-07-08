module BankHolidayHelpers
  def stub_bank_holidays!(contents)
    allow(File).to receive(:exists?).with(Settings.bank_holidays.file_location).and_return(true)
    allow(File).to receive(:open).with(anything).and_call_original
    allow(File).to receive(:open).with(Settings.bank_holidays.file_location).and_return(contents)
  end
end
