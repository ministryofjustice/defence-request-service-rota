require "rails_helper"

RSpec.describe ShiftRequirementsController do
  describe "PATCH update" do
    it "renders edit if the shift requirements could not be updated" do
      stub_signed_in_user
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

  def stub_signed_in_user
    allow_any_instance_of(ShiftRequirementsController).
      to receive(:current_user).and_return(double(:mock_user))
  end
end
