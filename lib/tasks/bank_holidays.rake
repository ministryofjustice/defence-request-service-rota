require_relative "../bank_holidays/fetcher"
require_relative "../bank_holidays/writer"

namespace :bank_holidays do
  desc "Pull Bank Holidays file from gov.uk"
  task get: :environment do
    file = BankHolidays::Fetcher.new(url: "https://www.gov.uk/bank-holidays/england-and-wales.ics").fetch
    BankHolidays::Writer.new(file_path: Rails.root.join("data", "bank_holidays.ics"),
                             contents: file).write
  end
end
