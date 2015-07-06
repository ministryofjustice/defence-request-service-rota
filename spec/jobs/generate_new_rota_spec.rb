require "rails_helper"
require "timecop"
require_relative "../../lib/rota_generation"

RSpec.describe RotaGenerationLogEntry do
  describe "#run" do
    let(:procurement_area) {
      create(:procurement_area)
    }

    let(:rota_slot) {
      build(:rota_slot)
    }

    let(:allocator) {
      double("slot allocator", allocate: [rota_slot])
    }

    let(:date_range) {
      double("date_range", build: "date_range")
    }

    let(:generator) {
      double("generator", generate_rota: [rota_slot])
    }

    let(:user) {
      create(:admin_user)
    }

    before :each do
      expect(DateRange).to receive(:new).and_return(date_range)
      expect(RotaSlotAllocator).to receive(:new).and_return(allocator)
      expect(RotaGeneration::Generator).to receive(:new).and_return(generator)
    end

    context "when the rota slots save successfully" do
      before :each do
        Timecop.freeze(2015, 1, 1, 1, 1, 1) do
          GenerateNewRota.enqueue("date_params", procurement_area.id, user.id)
        end
      end

      it "creates a successful journal entry" do
        expect(RotaGenerationLogEntry.count).to eq 1

        expect(RotaGenerationLogEntry.last.procurement_area_id).to eq procurement_area.id
        expect(RotaGenerationLogEntry.last.user_id).to eq user.id
        expect(RotaGenerationLogEntry.last.status).to eq "successful"
        expect(RotaGenerationLogEntry.last.total_slots).to eq 1
        expect(RotaGenerationLogEntry.last.start_time).to eq Time.parse("01-01-2015 01:01:01")
        expect(RotaGenerationLogEntry.last.end_time).to be_present
      end

      it "puts the rota slots into the database" do
        expect(RotaSlot.count).to eq 1
      end
    end

    context "when the rota slots fail to save" do
      before :each do
        expect(rota_slot).to receive(:save).and_return(false)

        Timecop.freeze(2015, 2, 2, 2, 2, 2) do
          GenerateNewRota.enqueue("date_params", procurement_area.id, user.id)
        end
      end

      it "creates a failed journal entry" do
        expect(RotaGenerationLogEntry.count).to eq 1

        expect(RotaGenerationLogEntry.last.procurement_area_id).to eq procurement_area.id
        expect(RotaGenerationLogEntry.last.user_id).to eq user.id
        expect(RotaGenerationLogEntry.last.status).to eq "failed"
        expect(RotaGenerationLogEntry.last.total_slots).to eq 1
        expect(RotaGenerationLogEntry.last.start_time).to eq Time.parse("02-02-2015 02:02:02")
        expect(RotaGenerationLogEntry.last.end_time).to be_present
      end

      it "does not put the rota slots into the database" do
        expect(RotaSlot.count).to eq 0
      end
    end
  end
end
