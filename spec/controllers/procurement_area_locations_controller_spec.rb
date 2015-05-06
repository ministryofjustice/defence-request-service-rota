require "rails_helper"

RSpec.describe ProcurementAreaLocationsController do
  include FakeDataApis

  describe "POST create" do
    it "adds a location to a procurement area" do
      set_data_api_to FakeDataApis::FakeLocationsApi
      stub_signed_in_user
      procurement_area = create :procurement_area
      location_params = {
        procurement_area_id: procurement_area.id,
        location_uid: "123abc456",
        location_type: "example"
      }

      post :create, location_params

      expect(response).to redirect_to procurement_area_path procurement_area
    end

    it "renders new if the location could not be added" do
      set_data_api_to FakeDataApis::FakeLocationsApi
      stub_signed_in_user
      procurement_area = create :procurement_area
      location_params = {
        procurement_area_id: procurement_area.id,
        location_uid: nil,
        location_type: nil
      }

      post :create, location_params

      expect(response).to render_template :new
    end
  end

  def stub_signed_in_user
    allow_any_instance_of(ProcurementAreaLocationsController).
      to receive(:current_user).and_return(double(:mock_user))
  end
end
