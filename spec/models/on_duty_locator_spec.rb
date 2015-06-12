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

  it "returns the single uid for the organisation on duty" do
    time = DateTime.parse("01/01/2014 20:00").iso8601

    create(:rota_slot,
           organisation_uid: firm_1,
           starting_time: DateTime.parse("01/01/2014 12:00"),
           shift: first_shift)

    create(:rota_slot,
           organisation_uid: firm_2,
           starting_time: DateTime.parse("01/01/2014 21:00"),
           shift: last_shift)

    on_duty_organisation_uids = OnDutyLocator.new(time, RotaSlot.all).locate

    expect(on_duty_organisation_uids).to eq [firm_1]
  end

  it "returns multiple uids for the organisations on duty" do
    time = DateTime.parse("01/01/2014 20:00").iso8601

    create(:rota_slot,
           organisation_uid: firm_1,
           starting_time: DateTime.parse("01/01/2014 12:00"),
           shift: first_shift)

    create(:rota_slot,
           organisation_uid: firm_2,
           starting_time: DateTime.parse("01/01/2014 12:00"),
           shift: first_shift)

    create(:rota_slot,
           organisation_uid: firm_3,
           starting_time: DateTime.parse("01/01/2014 21:00"),
           shift: last_shift)

    on_duty_organisation_uids = OnDutyLocator.new(time, RotaSlot.all).locate

    expect(on_duty_organisation_uids).to match_array([firm_1, firm_2])
  end

  it "returns the correct uid even if it not the first slot in time" do
    time = DateTime.parse("01/01/2014 22:00").iso8601

    create(:rota_slot,
           organisation_uid: firm_1,
           starting_time: DateTime.parse("01/01/2014 12:00"),
           shift: first_shift)

    create(:rota_slot,
           organisation_uid: firm_2,
           starting_time: DateTime.parse("01/01/2014 12:00"),
           shift: first_shift)

    create(:rota_slot,
           organisation_uid: firm_3,
           starting_time: DateTime.parse("01/01/2014 21:00"),
           shift: last_shift)

    on_duty_organisation_uids = OnDutyLocator.new(time, RotaSlot.all).locate

    expect(on_duty_organisation_uids).to match_array([firm_3])
  end

  it "returns no organisation uids if in a defined gap between shifts" do
    time = DateTime.parse("01/01/2014 17:00")

    create(:rota_slot,
           organisation_uid: firm_1,
           starting_time: DateTime.parse("01/01/2014 08:00"),
           ending_time: DateTime.parse("01/01/2014 16:00"))

    create(:rota_slot,
           organisation_uid: firm_1,
           starting_time: DateTime.parse("02/01/2014 08:00"),
           ending_time: DateTime.parse("02/01/2014 16:00"))

    on_duty_organisation_uids = OnDutyLocator.new(time, RotaSlot.all).locate

    expect(on_duty_organisation_uids).to match_array([])
  end

  it "returns no organisation uids if before all slots" do
    time = DateTime.parse("01/01/2014 06:00")

    create(:rota_slot,
           organisation_uid: firm_1,
           starting_time: DateTime.parse("01/01/2014 08:00"),
           ending_time: DateTime.parse("01/01/2014 16:00"))

    on_duty_organisation_uids = OnDutyLocator.new(time, RotaSlot.all).locate

    expect(on_duty_organisation_uids).to match_array([])
  end
end
