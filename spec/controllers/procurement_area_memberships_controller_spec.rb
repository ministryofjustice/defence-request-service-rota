require "rails_helper"

RSpec.describe ProcurementAreaMembershipsController do
  include FakeDataApis

  describe "POST create" do
    it "adds a membership to a procurement area" do
      set_data_api_to FakeDataApis::FakeLawFirmsApi
      stub_signed_in_user
      procurement_area = create :procurement_area
      membership_params = {
        procurement_area_id: procurement_area.id,
        membership_uid: "123abc456",
        membership_type: "example"
      }

      post :create, membership_params

      expect(response).to redirect_to procurement_area_path procurement_area
    end

    it "renders new if the membership could not be added" do
      set_data_api_to FakeDataApis::FakeLawFirmsApi
      stub_signed_in_user
      procurement_area = create :procurement_area
      membership_params = {
        procurement_area_id: procurement_area.id,
        membership_uid: nil,
        membership_type: nil
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
