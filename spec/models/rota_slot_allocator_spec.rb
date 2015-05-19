require "rails_helper"

RSpec.describe RotaSlotAllocator, "#allocate" do
  it "instantiates the necessary number of rota slots per shift weekday requirement" do
    date_range = Range.new(Date.parse("1/1/2015"), Date.parse("2/1/2015"))
    shifts = [
      build_stubbed(:shift, thursday: 1),
      build_stubbed(:shift, friday: 1)
    ]

    allocation = RotaSlotAllocator.new(date_range: date_range, shifts: shifts).allocate

    expect(allocation.map(&:class).uniq).to eq [RotaSlot]
    expect(allocation.length).to eq 2
  end
end
