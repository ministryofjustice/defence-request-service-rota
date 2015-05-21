require "rails_helper"

RSpec.describe LocationShiftsController do
  include FakeDataApis

  it { should be_kind_of(ApiEnabledController) }

  describe "POST create" do
    it "renders new if the shift could not be added" do
      set_data_api_to FakeDataApis::FakeLocationsApi
      stub_signed_in_user
      location_shift_params = {
        location_shift_form: {
          name: "",
          location_uid: "abc"
        }
      }

      post :create, location_shift_params

      expect(response).to render_template :new
    end
  end

  describe "PATCH update" do
    it "renders edit if the shift could not be updated" do
      set_data_api_to FakeDataApis::FakeLocationsApi
      stub_signed_in_user
      shift = create :shift
      location_shift_params = {
        id: shift.id,
        shift: {
          name: "",
          starting_time: nil,
          location_uid: shift.location_uid
        }
      }

      patch :update, location_shift_params

      expect(response).to render_template :edit
    end
  end

  def stub_signed_in_user
    allow_any_instance_of(LocationShiftsController).
      to receive(:current_user).and_return(double(:mock_user))
  end
end
