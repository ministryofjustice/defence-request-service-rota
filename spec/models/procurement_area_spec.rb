require "rails_helper"

RSpec.describe ProcurementArea, "validations" do
  it { should validate_presence_of(:name) }
end

RSpec.describe ProcurementArea, "relationships" do
  it { should have_many(:rota_slots) }
  it { should have_many(:organisations) }
  it { should have_many(:rota_generation_log_entries) }

  it "removes any rota slots associated with it upon destroying" do
    p = create(:procurement_area)

    create_list(:rota_slot, 3, procurement_area: p)

    p.destroy

    expect(RotaSlot.count).to eq 0
  end
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

RSpec.describe ProcurementArea, "#members" do
  it "returns all associated organisations with a member type" do
    p = create(:procurement_area)

    law_firm = create(:organisation,
                      organisation_type: "law_firm",
                      procurement_area: p)
    create(:organisation,
           organisation_type: "custody_suite",
           procurement_area: p)
    create(:organisation,
           organisation_type: "law_firm")

    expect(p.members).to eq([law_firm])
  end
end

RSpec.describe ProcurementArea, "#locations" do
  it "returns all associated organisations with a location type" do
    p = create(:procurement_area)

    custody_suite = create(:organisation,
                           organisation_type: "custody_suite",
                           procurement_area: p)
    create(:organisation,
           organisation_type: "law_firm",
           procurement_area: p)
    create(:organisation,
           organisation_type: "custody_suite")

    expect(p.locations).to eq([custody_suite])
  end
end
