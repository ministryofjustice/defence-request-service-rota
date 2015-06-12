class Api::V1::OnDutyFirmsController < Api::V1::ApiController
  def show
    organisations_on_duty = OnDutyLocator.new(
      requested_time,
      rota_slots_for_location
    ).locate

    render json: { "organisation_uids" => organisations_on_duty }
  end

  def some_method

  end
  private

  def rota_slots_for_location
    RotaSlot.joins(:shift).where(shifts: { location_uid: requested_location },
                                 starting_time: (Time.parse(requested_time) - 2.days)..(Time.parse(requested_time) + 2.days))
  end

  def requested_location
    params.fetch(:location_uid)
  end

  def requested_time
    params.fetch(:time)
  end
end
