class LocationShiftsController < ApiEnabledController
  def show
    @location = location

    @location_shifts = Shift.for(location.uid).map { |shift| ShiftPresenter.new(shift) }
  end

  def new
    @location_shift_form = LocationShiftForm.new(location_uid: location.uid)
  end

  def create
    @location_shift_form = LocationShiftForm.new(
      location_shift_params_from(params[:location_shift_form])
    )

    if @location_shift_form.submit
      redirect_to location_shift_path(
        @location_shift_form.location_shift,
        location_id: @location_shift_form.location_uid
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
        location_id: @location_shift.location_uid
      )
    else
      render :edit
    end
  end

  def destroy
    @location_shift = location_shift

    @location_shift.destroy

    redirect_to location_shift_path(location_id: @location_shift.location_uid)
  end

  private

  def location
    find_organisation_by_uid(uid: params[:location_id])
  end

  def location_shift
    Shift.find(params[:id])
  end

  def location_shift_params_from(params_for_action)
    {
      name: params_for_action.fetch(:name),
      location_uid: params_for_action.fetch(:location_uid),
      starting_time: StartingTime.new(params_for_action).build,
      ending_time: EndingTime.new(params_for_action).build,
    }
  end
end
