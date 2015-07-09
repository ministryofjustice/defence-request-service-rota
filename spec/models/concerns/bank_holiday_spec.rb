require "rails_helper"

RSpec.describe BankHoliday, type: :bank_holidays do
  before :each do
    stub_bank_holidays!([Date.new(2012, 1, 2)])
  end

  describe "#is_bank_holiday" do
    it "returns true for a date which is in the bank holidays file" do
      expect(Date.new(2012, 1, 2).is_bank_holiday?).to be_truthy
    end

    it "returns false for a date which is not in the bank holidays file" do
      expect(Date.new(2012, 6, 1).is_bank_holiday?).to be_falsey
    end
  end
end
