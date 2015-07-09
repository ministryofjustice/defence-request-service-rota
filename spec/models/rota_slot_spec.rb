require "rails_helper"

RSpec.describe RotaSlot, "validations" do
  it { should validate_presence_of(:starting_time) }
  it { should validate_presence_of(:shift) }

  it "does not violate the uniquness between shift and start time" do
    shift = create(:shift)

    create(:rota_slot, shift: shift, starting_time: Time.parse("01/01/2015 09:00"))

    expect(
      build(
        :rota_slot,
        shift: shift,
        starting_time: Time.parse("01/01/2015 09:00")
      )
    ).not_to be_valid
  end
end

RSpec.describe RotaSlot, "relationships" do
  it { should belong_to(:shift) }
  it { should belong_to(:procurement_area) }
end
