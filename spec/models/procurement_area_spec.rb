require "rails_helper"

RSpec.describe ProcurementArea, "validations" do
  it { should validate_presence_of(:name) }
end

RSpec.describe ProcurementArea, ".ordered_by_name" do
  it "returns all procurement areas ordered by name" do
    [
      create(:procurement_area, name: "Be-Morpork"),
      create(:procurement_area, name: "Ce-Morpork"),
      create(:procurement_area, name: "Ankh-Morpork")
    ]

    ordered_procurement_areas = ProcurementArea.ordered_by_name

    expect(ordered_procurement_areas.map(&:name)).
      to eq ["Ankh-Morpork", "Be-Morpork", "Ce-Morpork"]
  end
end
