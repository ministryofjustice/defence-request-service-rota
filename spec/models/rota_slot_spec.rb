require "rails_helper"

RSpec.describe RotaSlot, "validations" do
  it { should validate_presence_of(:date) }
  it { should validate_presence_of(:shift) }
  it { should validate_presence_of(:organisation_uid) }
end

RSpec.describe RotaSlot, "relationships" do
  it { should belong_to(:shift) }
  it { should belong_to(:procurement_area) }
end
