require "spec_helper"
require_relative "../../../lib/bank_holidays/writer"

RSpec.describe BankHolidays::Writer, "#write" do
  it "writes out to the provided file" do
    expect(File).to receive(:open).with("a_file", "w")

    BankHolidays::Writer.new(file_path: "a_file", contents: "file_contents").write
  end
end
