class Api::V1::OnDutyFirmsController < Api::V1::ApiController
  def show
    organisation_on_duty = OnDutyLocator.new(
      requested_time,
      rota_slots_for_location
    ).locate

    render json: { "organisation_uid" => organisation_on_duty }
  end

  def some_method

  end
  private

  def rota_slots_for_location
    RotaSlot.where(shift_id: Shift.where(location_uid: requested_location))
  end

  def requested_location
    params.fetch(:location_uid)
  end

  def requested_time
    params.fetch(:time)
  end
end
