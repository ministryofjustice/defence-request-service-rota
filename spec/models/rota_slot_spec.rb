require "rails_helper"

RSpec.describe RotaSlot, "validations" do
  it { should validate_presence_of(:starting_time) }
  it { should validate_presence_of(:shift) }
  it { should validate_presence_of(:organisation_uid) }
end

RSpec.describe RotaSlot, "relationships" do
  it { should belong_to(:shift) }
  it { should belong_to(:procurement_area) }
end

RSpec.describe "#update_request_count!" do
  it "should increment the request count" do
    rota_slot = create(:rota_slot)

    expect {
      rota_slot.update_request_count!
    }.to change {
      rota_slot.request_count
    }.by(1)
  end
end
