require "rails_helper"

RSpec.describe "GET /v1/on_duty_firm/:location_uid/:time" do
  it_behaves_like "a protected endpoint", "/v1/on_duty_firm"

  context "with an authorization token" do
    include_context "valid client token"

    let(:court_uid) { SecureRandom.uuid }
    let(:procurement_area) {
      create(:procurement_area,
             memberships: [{ uid: court_uid, type: "court" }]
            )
    }

    it "returns the organisation_uid of the law firm on duty" do
      on_duty_firm_uid = SecureRandom.uuid

      create(
        :rota_slot,
        starting_time: Time.parse("01/01/2014 09:00"),
        ending_time: Time.parse("01/01/2014 21:00"),
        shift: create(:shift, location_uid: court_uid),
        organisation_uid: on_duty_firm_uid,
        procurement_area_id: procurement_area.id
      )

      get "/v1/on_duty_firm/", {
        location_uid: court_uid,
        time: Time.parse("01/01/2014 20:00").iso8601
      }, api_request_headers

      expect(response_json).to eq({ "organisation_uid" => on_duty_firm_uid })
    end

    it "rotates between several organisation_uids if there are several on duty" do
      firm_1 = SecureRandom.uuid
      firm_2 = SecureRandom.uuid

      create(:rota_slot,
             starting_time: Time.parse("01/01/2014 09:00"),
             ending_time: Time.parse("01/01/2014 21:00"),
             shift: create(:shift, location_uid: court_uid),
             organisation_uid: firm_1,
             procurement_area_id: procurement_area.id
            )

      create(:rota_slot,
             starting_time: Time.parse("01/01/2014 09:00"),
             ending_time: Time.parse("01/01/2014 21:00"),
             shift: create(:shift, location_uid: court_uid),
             organisation_uid: firm_2,
             procurement_area_id: procurement_area.id
            )

      get "/v1/on_duty_firm/", {
        location_uid: court_uid,
        time: Time.parse("01/01/2014 10:00").iso8601
      }, api_request_headers

      expect(response_json).to eq({ "organisation_uid" => firm_1 })

      get "/v1/on_duty_firm/", {
        location_uid: court_uid,
        time: Time.parse("01/01/2014 11:00").iso8601
      }, api_request_headers

      expect(response_json).to eq({ "organisation_uid" => firm_2 })
    end
  end
end
