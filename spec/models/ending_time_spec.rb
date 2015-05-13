require_relative "../../app/models/ending_time"

RSpec.describe EndingTime, "#build" do
  context "when provided with ending time information" do
    it "returns a parsed time string" do
      ending_time_information = {
        "ending_time(1i)" => "2015",
        "ending_time(2i)" => "5",
        "ending_time(3i)" => "11",
        "ending_time(4i)" => "08",
        "ending_time(5i)" => "00",
      }

      ending_time = EndingTime.new(ending_time_information).build

      expect(ending_time).to eq Time.parse("08:00").to_s
    end
  end

  context "when the ending time information is blank" do
    it "returns nil" do
      ending_time_information = {
        "ending_time(1i)" => "2015",
        "ending_time(2i)" => "5",
        "ending_time(3i)" => "11",
        "ending_time(4i)" => "",
        "ending_time(5i)" => "",
      }

      ending_time = EndingTime.new(ending_time_information).build

      expect(ending_time).to eq nil
    end
  end

  context "when no ending time information is provided" do
    it "returns nil" do
      ending_time_information = {}

      ending_time = EndingTime.new(ending_time_information).build

      expect(ending_time).to eq nil
    end
  end
end
