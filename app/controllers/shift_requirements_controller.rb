class ShiftRequirementsController < ApplicationController
  def edit
    @shift = shift
  end

  def update
    @shift = shift

    if @shift.update_attributes(shift_requirements_params)
      redirect_to location_shift_path(@shift, organisation_id: @shift.organisation_id)
    else
      render :edit
    end
  end

  private

  def shift
    Shift.find(params[:id])
  end

  def shift_requirements_params
    params.require(:shift).permit(
      :monday,
      :tuesday,
      :wednesday,
      :thursday,
      :friday,
      :saturday,
      :sunday,
      :bank_holiday
    )
  end
end
