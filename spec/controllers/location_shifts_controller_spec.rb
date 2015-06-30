require "rails_helper"

RSpec.describe LocationShiftsController do
  before do
    sign_in(create(:admin_user))
  end

  describe "POST create" do
    it "renders new if the shift could not be added" do
      location_shift_params = {
        location_shift_form: {
          name: "",
          organisation_id: 1
        }
      }

      post :create, location_shift_params

      expect(response).to render_template :new
    end
  end

  describe "PATCH update" do
    it "renders edit if the shift could not be updated" do
      shift = create :shift

      location_shift_params = {
        id: shift.id,
        shift: {
          name: "",
          starting_time: nil,
          organisation_id: shift.organisation_id
        }
      }

      patch :update, location_shift_params

      expect(response).to render_template :edit
    end
  end
end
