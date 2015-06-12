require "rails_helper"

RSpec.describe OnDutyLocator, "#locate" do
  it "returns the uid for the organisation on duty" do
    firm_uid = "32252f6a-a6a5-4f52-8ede-58d6127ba231"
    time = DateTime.parse("01/01/2014 20:00").iso8601
    first_shift = build_stubbed :shift, starting_time: Time.parse("12:00")
    last_shift = build_stubbed :shift, starting_time: Time.parse("21:00")

    create(:rota_slot, organisation_uid: firm_uid, starting_time: DateTime.parse("01/01/2014 12:00"), shift: first_shift)
    create(:rota_slot, starting_time: DateTime.parse("01/01/2014 21:00"), shift: last_shift)

    on_duty_organisation_uid = OnDutyLocator.new(time, RotaSlot.all).locate

    expect(on_duty_organisation_uid).to eq firm_uid
  end
end
