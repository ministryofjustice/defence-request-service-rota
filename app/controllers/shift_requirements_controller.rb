class ShiftRequirementsController < ApplicationController
  def edit
    @shift = shift
  end

  def update
    @shift = shift

    @shift.update_attributes(shift_requirements_params)

    redirect_to location_shift_path(@shift, location_id: @shift.location_uid)
  end

  private

  def shift
    Shift.find(params[:id])
  end

  def shift_requirements_params
    params.require(:shift).permit(Date::DAYS_INTO_WEEK.keys)
  end
end
