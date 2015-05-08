require_relative "../../app/models/starting_time"

RSpec.describe StartingTime, "#build" do
  context "when provided with starting time information" do
    it "returns a parsed time string" do
      starting_time_information = {
        "starting_time(1i)" => "2015",
        "starting_time(2i)" => "5",
        "starting_time(3i)" => "11",
        "starting_time(4i)" => "08",
        "starting_time(5i)" => "00",
      }

      starting_time = StartingTime.new(starting_time_information).build

      expect(starting_time).to eq Time.parse("08:00").to_s
    end
  end

  context "when the starting time information is blank" do
    it "returns an empty string" do
      starting_time_information = {
        "starting_time(1i)" => "2015",
        "starting_time(2i)" => "5",
        "starting_time(3i)" => "11",
        "starting_time(4i)" => "",
        "starting_time(5i)" => "",
      }

      starting_time = StartingTime.new(starting_time_information).build

      expect(starting_time).to eq ""
    end
  end

  context "when no starting time information is provided" do
    it "returns an empty string" do
      starting_time_information = {}

      starting_time = StartingTime.new(starting_time_information).build

      expect(starting_time).to eq ""
    end
  end
end
