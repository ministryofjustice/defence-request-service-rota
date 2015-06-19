require_relative "../../app/models/filter_range"
require "active_support/core_ext/time"

RSpec.describe FilterRange, "#build" do
  it "builds a time range from the params passed in" do
    params = {
      "starting_date(1i)" => "2015",
      "starting_date(2i)" => "1",
      "starting_date(3i)" => "1",
      "ending_date(1i)" => "2015",
      "ending_date(2i)" => "1",
      "ending_date(3i)" => "20"
    }

    filter_range = FilterRange.new(params).build

    expect(filter_range.begin).to eq Time.parse("2015/1/1").beginning_of_day
    expect(filter_range.end).to eq Time.parse("2015/1/20").end_of_day
  end
end
