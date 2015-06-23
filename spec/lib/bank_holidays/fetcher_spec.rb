require "spec_helper"
require "httparty"
require_relative "../../../lib/bank_holidays/fetcher"

RSpec.describe BankHolidays::Fetcher, "#fetch" do
  it "raises an error if HTTParty fails" do
    expect(HTTParty).to receive(:get).
      with("url").
      and_return(double(:res, code: 404))

    expect { BankHolidays::Fetcher.new(url: "url").fetch }.to raise_error
  end

  it "writes the contents out to a file if successful" do
    expect(HTTParty).to receive(:get).
      with("url").
      and_return(double(:res, code: 200, body: "FAKE FILE"))

    expect(BankHolidays::Fetcher.new(url: "url").fetch).to eq "FAKE FILE"
  end
end
