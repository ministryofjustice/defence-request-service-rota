class Api::V1::OnDutyFirmsController < Api::V1::ApiController
  def show
    organisation_on_duty = OnDutyLocator.new(
      requested_time,
      rota_slots_for_location
    ).locate

    render json: { "organisation_uid" => organisation_on_duty }
  end

  private

  def rota_slots_for_location
    RotaSlot.joins(:shift)
      .where(
        shifts: { location_uid: requested_location },
        starting_time: surrounding_time_window
      ).order(starting_time: :desc)
  end

  def requested_location
    params.fetch(:location_uid)
  end

  def requested_time
    params.fetch(:time)
  end

  def surrounding_time_window
    (Time.parse(requested_time) - 2.days)..(Time.parse(requested_time) + 2.days)
  end
end
