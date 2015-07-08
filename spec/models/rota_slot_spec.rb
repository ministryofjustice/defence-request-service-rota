require "rails_helper"

RSpec.describe RotaSlot, "validations" do
  it { should validate_presence_of(:starting_time) }
  it { should validate_presence_of(:shift) }
end

RSpec.describe RotaSlot, "relationships" do
  it { should belong_to(:shift) }
  it { should belong_to(:procurement_area) }
end
