require "rails_helper"

RSpec.describe "GET /api/v1/on_duty_firm/:location_uid/:time" do
  it_behaves_like "a protected endpoint", "/api/v1/on_duty_firm"

  context "with an authorization token" do
    include_context "valid client token"

    let(:procurement_area) {
      create(:procurement_area)
    }
    let(:court) {
      create(:organisation,
             organisation_type: "court",
             procurement_area: procurement_area)
    }

    it "returns the organisation_uid of the law firm on duty" do
      law_firm = create(:organisation,
                        organisation_type: "law_firm",
                        procurement_area: procurement_area)

      create(
        :rota_slot,
        starting_time: Time.parse("01/01/2014 09:00"),
        ending_time: Time.parse("01/01/2014 21:00"),
        shift: create(:shift, organisation: court),
        organisation: law_firm,
        procurement_area_id: procurement_area.id
      )

      get "/api/v1/on_duty_firm/", {
        organisation_id: court.id,
        time: Time.parse("01/01/2014 20:00").iso8601
      }, api_request_headers

      expect(response_json).to eq({ "organisation_id" => law_firm.id })
    end

    it "rotates between several organisation_uids if there are several on duty" do
      firm_1 = create(:organisation, organisation_type: "law_firm", procurement_area: procurement_area)
      firm_2 = create(:organisation, organisation_type: "law_firm", procurement_area: procurement_area)

      create(:rota_slot,
             starting_time: Time.parse("01/01/2014 09:00"),
             ending_time: Time.parse("01/01/2014 21:00"),
             shift: create(:shift, organisation: court),
             organisation: firm_1,
             procurement_area_id: procurement_area.id
            )

      create(:rota_slot,
             starting_time: Time.parse("01/01/2014 09:00"),
             ending_time: Time.parse("01/01/2014 21:00"),
             shift: create(:shift, organisation: court),
             organisation: firm_2,
             procurement_area_id: procurement_area.id
            )

      get "/api/v1/on_duty_firm/", {
        organisation_id: court.id,
        time: Time.parse("01/01/2014 10:00").iso8601
      }, api_request_headers

      expect(response_json).to eq({ "organisation_id" => firm_1.id })

      get "/api/v1/on_duty_firm/", {
        organisation_id: court.id,
        time: Time.parse("01/01/2014 11:00").iso8601
      }, api_request_headers

      expect(response_json).to eq({ "organisation_id" => firm_2.id })
    end
  end
end
