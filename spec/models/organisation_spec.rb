require "rails_helper"

RSpec.describe Organisation do
  describe "validations" do
    it { expect(subject).to validate_presence_of :name }
    it { expect(subject).to validate_presence_of :organisation_type }
    it {
      expect(subject).to validate_inclusion_of(:organisation_type).
        in_array(Organisation::ORGANISATION_TYPES)
    }
    it { expect(subject).to_not allow_value("doesnt_exist") .for(:organisation_type) }
  end

  describe "relationships" do
    it { expect(subject).to belong_to(:procurement_area) }
    it { expect(subject).to have_many(:shifts) }
  end

  describe "scopes" do
    describe ".by_name" do
      it "returns organisations in alphabetical order" do
        create :organisation, name: "First Organisation"
        create :organisation, name: "Second Organisation"
        create :organisation, name: "Third Organisation"

        expect(Organisation.by_name.pluck(:name)).to eq [
          "First Organisation",
          "Second Organisation",
          "Third Organisation"
        ]
      end
    end
  end
end
