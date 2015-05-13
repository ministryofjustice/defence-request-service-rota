class LocationShiftsController < ApplicationController
  def show
    @location = location

    @location_shifts = Shift.for(location).map do |shift|
      LocationShift.new(shift)
    end
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
    OrganisationFinder.new(api_client, uid: location_id).find
  end

  def location_shift
    Shift.find(params[:id])
  end

  def api_client
    DefenceRequestServiceRota.service(:auth_api).new(session[:user_token])
  end

  def location_id
    params[:location_id]
  end

  def location_shift_params_from(action_params)
    {
      name: action_params.fetch(:name),
      location_uid: action_params.fetch(:location_uid),
      starting_time: StartingTime.new(action_params).build,
      ending_time: EndingTime.new(action_params).build,
    }
  end
end
