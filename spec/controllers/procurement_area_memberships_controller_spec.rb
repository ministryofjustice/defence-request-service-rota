require "rails_helper"

RSpec.describe ProcurementAreaMembershipsController do
  include FakeDataApis

  it { should be_kind_of(ApiEnabledController) }

  describe "POST create" do
    it "adds a member to a procurement area" do
      stub_signed_in_user
      procurement_area = create(:procurement_area)
      new_member = create(:organisation)
      membership_params = {
        procurement_area_id: procurement_area.id,
        membership_id: new_member.id
      }

      post :create, membership_params

      expect(response).to redirect_to procurement_area_path procurement_area
    end

    it "renders new if the membership could not be added" do
      stub_signed_in_user
      procurement_area = create :procurement_area
      membership_params = {
        procurement_area_id: procurement_area.id,
        membership_id: nil
      }

      post :create, membership_params

      expect(response).to render_template :new
    end
  end

  def stub_signed_in_user
    allow_any_instance_of(ProcurementAreaMembershipsController).
      to receive(:current_user).and_return(double(:mock_user))
  end
end
