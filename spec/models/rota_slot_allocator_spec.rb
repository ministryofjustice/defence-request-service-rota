require "rails_helper"

RSpec.describe RotaSlotAllocator, "#allocate" do
  it "instantiates the necessary number of rota slots per shift weekday requirement" do
    date_range = Range.new(Date.parse("1/1/2015"), Date.parse("3/1/2015"))
    shifts = [
      build_stubbed(:shift, thursday: 1, starting_time: "09:00"),
      build_stubbed(:shift, friday: 1, starting_time: "11:00", ending_time: "19:00"),
      build_stubbed(:shift, saturday: 1, starting_time: "15:00", ending_time: "15:00")
    ]
    procurement_area = build_stubbed :procurement_area

    allocation = RotaSlotAllocator.new(
      date_range: date_range,
      shifts: shifts,
      procurement_area: procurement_area
    ).allocate

    expect(allocation.map(&:class).uniq).to eq [RotaSlot]
    expect(allocation.length).to eq 3

    expect(allocation[0].starting_time).to eq Time.parse("1/1/2015 09:00")
    expect(allocation[0].ending_time).to   eq nil

    expect(allocation[1].starting_time).to eq Time.parse("2/1/2015 11:00")
    expect(allocation[1].ending_time).to   eq Time.parse("2/1/2015 19:00")

    expect(allocation[2].starting_time).to eq Time.parse("3/1/2015 15:00")
    expect(allocation[2].ending_time).to   eq Time.parse("4/1/2015 15:00")
  end
end
