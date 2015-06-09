require_relative "../../app/models/date_range"

RSpec.describe DateRange, "#build" do
  it "builds a date range from the params passed in" do
    params = {
      "starting_date(1i)" => "2015",
      "starting_date(2i)" => "1",
      "starting_date(3i)" => "1",
      "ending_date(1i)" => "2015",
      "ending_date(2i)" => "1",
      "ending_date(3i)" => "20"
    }

    date_range = DateRange.new(params).build

    expect(date_range.begin).to eq Date.parse("2015/1/1")
    expect(date_range.end).to eq Date.parse("2015/1/20")
  end
end
