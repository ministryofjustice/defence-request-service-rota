require "rails_helper"

RSpec.describe ShiftRequirementsController, type: :controller do
  describe "PATCH update" do
    it "renders edit if the shift requirements could not be updated" do
      sign_in(create(:admin_user))

      shift = create :shift
      shift_params = {
        id: shift.id,
        shift: {
          monday: nil,
          tuesday: -7
        }
      }

      patch :update, shift_params

      expect(response).to render_template :edit
    end
  end
end
