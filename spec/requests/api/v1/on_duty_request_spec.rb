require "rails_helper"

RSpec.describe "GET /v1/on_duty_firm/:location_uid/:time" do
  it "returns the organisation_uid of the law firm on duty" do
    on_duty_firm = {
      uid: "32252f6a-a6a5-4f52-8ede-58d6127ba231",
      name: "Guilded Groom & Groom",
      type: "law_firm"
    }
    procurement_area = create(
      :procurement_area,
      memberships: [{ uid: "93b8ef50-fe12-4d80-9e7e-05e98232ec13", type: "court" }]
    )
    create(
      :rota_slot,
      starting_time: DateTime.parse("01/01/2014 09:00"),
      ending_time: DateTime.parse("01/01/2014 21:00"),
      shift: create(:shift, location_uid: "93b8ef50-fe12-4d80-9e7e-05e98232ec13"),
      organisation_uid: "32252f6a-a6a5-4f52-8ede-58d6127ba231",
      procurement_area_id: procurement_area.id
    )

    get "/v1/on_duty_firm/", {
      location_uid: "93b8ef50-fe12-4d80-9e7e-05e98232ec13",
      time: DateTime.parse("01/01/2014 20:00").iso8601,
      token: "611151277c992292868f772d573da4eea4ade37e303582b328c674e8ce69b512",
    }

    expect(response_json).to eq({ "organisation_uids" => [ on_duty_firm[:uid] ] })
  end
end
