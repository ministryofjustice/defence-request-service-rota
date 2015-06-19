require "rails_helper"

RSpec.describe OnDutyLocator, "#locate" do
  let(:firm_1) { SecureRandom.uuid }
  let(:firm_2) { SecureRandom.uuid }
  let(:firm_3) { SecureRandom.uuid }

  let(:first_shift) { build_stubbed :shift, starting_time: Time.parse("12:00") }
  let(:last_shift)  { build_stubbed :shift, starting_time: Time.parse("21:00") }

  let(:defined_shift) {
    build_stubbed :shift,
    starting_time: Time.parse("08:00"),
    ending_date: Time.parse("16:00")
  }

  context "when one firm is on duty" do
    it "returns the single uid for the organisation" do
      time = Time.parse("01/01/2014 20:00").iso8601

      create(:rota_slot,
             organisation_uid: firm_1,
             starting_time: Time.parse("01/01/2014 12:00"),
             shift: first_shift)

      create(:rota_slot,
             organisation_uid: firm_2,
             starting_time: Time.parse("01/01/2014 21:00"),
             shift: last_shift)

      on_duty_organisation_uid = OnDutyLocator.new(time, RotaSlot.order(starting_time: :desc)).locate

      expect(on_duty_organisation_uid).to eq firm_1
    end

    it "updates the request count for that slot" do
      time = Time.parse("01/01/2014 20:00").iso8601

      rota_slot = create(:rota_slot,
                         organisation_uid: firm_1,
                         starting_time: Time.parse("01/01/2014 12:00"),
                         shift: first_shift,
                         request_count: 6)

      expect {
        OnDutyLocator.new(time, RotaSlot.order(starting_time: :desc)).locate
      }.to change {
        rota_slot.reload.request_count
      }.by(1)
    end

    it "returns the correct uid even if it not the first slot in time" do
      time = Time.parse("01/01/2014 22:00").iso8601

      create(:rota_slot,
             organisation_uid: firm_1,
             starting_time: Time.parse("01/01/2014 12:00"),
             shift: first_shift)

      create(:rota_slot,
             organisation_uid: firm_2,
             starting_time: Time.parse("01/01/2014 12:00"),
             shift: first_shift)

      create(:rota_slot,
             organisation_uid: firm_3,
             starting_time: Time.parse("01/01/2014 21:00"),
             shift: last_shift)

      on_duty_organisation_uid = OnDutyLocator.new(time, RotaSlot.order(starting_time: :desc)).locate

      expect(on_duty_organisation_uid).to eq firm_3
    end

    it "returns no organisation uids if in a defined gap between shifts" do
      time = Time.parse("01/01/2014 17:00")

      create(:rota_slot,
             organisation_uid: firm_1,
             starting_time: Time.parse("01/01/2014 08:00"),
             ending_time: Time.parse("01/01/2014 16:00"))

      create(:rota_slot,
             organisation_uid: firm_1,
             starting_time: Time.parse("02/01/2014 08:00"),
             ending_time: Time.parse("02/01/2014 16:00"))

      on_duty_organisation_uid = OnDutyLocator.new(time, RotaSlot.order(starting_time: :desc)).locate

      expect(on_duty_organisation_uid).to be_nil
    end

    it "returns no organisation uids if before all slots" do
      time = Time.parse("01/01/2014 06:00")

      create(:rota_slot,
             organisation_uid: firm_1,
             starting_time: Time.parse("01/01/2014 08:00"),
             ending_time: Time.parse("01/01/2014 16:00"))

      on_duty_organisation_uid = OnDutyLocator.new(time, RotaSlot.order(starting_time: :desc)).locate

      expect(on_duty_organisation_uid).to be_nil
    end
  end

  context "when multiple firms are on duty" do
    it "returns the organisation which has had the least requests" do
      time = Time.parse("01/01/2014 20:00").iso8601

      create(:rota_slot,
             organisation_uid: firm_1,
             starting_time: Time.parse("01/01/2014 12:00"),
             shift: first_shift,
             request_count: 3)

      create(:rota_slot,
             organisation_uid: firm_2,
             starting_time: Time.parse("01/01/2014 12:00"),
             shift: first_shift,
             request_count: 1)

      on_duty_organisation_uid = OnDutyLocator.new(time, RotaSlot.order(starting_time: :desc)).locate

      expect(on_duty_organisation_uid).to eq firm_2
    end

    it "returns the first organisation if all have had the same number of requests" do
      time = Time.parse("01/01/2014 20:00").iso8601

      create(:rota_slot,
             organisation_uid: firm_1,
             starting_time: Time.parse("01/01/2014 12:00"),
             shift: first_shift,
             request_count: 2)

      create(:rota_slot,
             organisation_uid: firm_2,
             starting_time: Time.parse("01/01/2014 12:00"),
             shift: first_shift,
             request_count: 2)

      on_duty_organisation_uid = OnDutyLocator.new(time, RotaSlot.order(starting_time: :desc)).locate

      expect(on_duty_organisation_uid).to eq firm_1
    end

    it "rotates after each call to #locate" do
      time = Time.parse("01/01/2014 20:00").iso8601

      slot_1 =  create(:rota_slot,
                       organisation_uid: firm_1,
                       starting_time: Time.parse("01/01/2014 12:00"),
                       shift: first_shift,
                       request_count: 2)

      slot_2 = create(:rota_slot,
                      organisation_uid: firm_2,
                      starting_time: Time.parse("01/01/2014 12:00"),
                      shift: first_shift,
                      request_count: 2)

      expect(OnDutyLocator.new(time, RotaSlot.order(starting_time: :desc)).locate).to eq firm_1
      expect(slot_1.reload.request_count).to eq 3

      expect(OnDutyLocator.new(time, RotaSlot.order(starting_time: :desc)).locate).to eq firm_2
      expect(slot_2.reload.request_count).to eq 3

      expect(OnDutyLocator.new(time, RotaSlot.order(starting_time: :desc)).locate).to eq firm_1
      expect(slot_1.reload.request_count).to eq 4
    end
  end
end
