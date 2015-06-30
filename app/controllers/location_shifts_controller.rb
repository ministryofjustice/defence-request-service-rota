class LocationShiftsController < ApplicationController
  def show
    @organisation = organisation

    @shifts = organisation.shifts.map { |shift| ShiftPresenter.new(shift) }
  end

  def new
    @location_shift_form = LocationShiftForm.new(organisation_id: organisation.id)
  end

  def create
    @location_shift_form = LocationShiftForm.new(
      location_shift_params_from(params[:location_shift_form])
    )

    if @location_shift_form.submit
      redirect_to location_shift_path(
        @location_shift_form.location_shift,
        organisation_id: @location_shift_form.organisation_id
      )
    else
      render :new
    end
  end

  def edit
    @location_shift = location_shift
  end

  def update
    @location_shift = location_shift

    if @location_shift.update_attributes(location_shift_params_from params[:shift])
      redirect_to location_shift_path(
        @location_shift,
        organisation_id: @location_shift.organisation_id
      )
    else
      render :edit
    end
  end

  def destroy
    @location_shift = location_shift

    @location_shift.destroy

    redirect_to location_shift_path(organisation_id: @location_shift.organisation_id)
  end

  private

  def organisation
    Organisation.find(params[:organisation_id])
  end

  def location_shift
    Shift.find(params[:id])
  end

  def location_shift_params_from(params_for_action)
    {
      name: params_for_action.fetch(:name),
      organisation_id: params_for_action.fetch(:organisation_id),
      starting_time: StartingTime.new(params_for_action).build,
      ending_time: EndingTime.new(params_for_action).build,
    }
  end
end
