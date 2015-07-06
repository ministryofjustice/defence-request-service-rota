require_relative "../../lib/rota_generation"

class GenerateNewRota < Que::Job
  def run(date_range_params, procurement_area_id)
    @date_range_params = date_range_params
    @procurement_area_id = procurement_area_id

    empty_rota_slots = allocated_rota_slots

    journal_entry = JournalEntry.running!(
      procurement_area_id: procurement_area_id,
      total_slots: empty_rota_slots.size
    )

    RotaGeneration::Generator.new(
      empty_rota_slots,
      member_ids
    ).generate_rota

    success = false

    RotaSlot.transaction do
      success = empty_rota_slots.all?(&:save)

      unless success
        raise ActiveRecord::Rollback, "Failed to update all rota slots."
      end

      # It's best to destroy the job in the same transaction as any other
      # changes you make. Que will destroy the job for you after the run
      # method if you don't do it yourself, but if your job writes to the
      # DB but doesn't destroy the job in the same transaction, it's
      # possible that the job could be repeated in the event of a crash.
      destroy
    end

    success ? journal_entry.success! : journal_entry.fail!
  end

  private

  attr_reader :date_range_params, :procurement_area_id

  def procurement_area
    ProcurementArea.find(procurement_area_id)
  end

  def allocated_rota_slots
    RotaSlotAllocator.new(
      date_range: build_date_range,
      shifts: shifts_for_location,
      procurement_area: procurement_area
    ).allocate
  end

  def build_date_range
    DateRange.new(date_range_params).build
  end

  def shifts_for_location
    procurement_area.locations.flat_map(&:shifts)
  end

  def member_ids
    procurement_area.members.flat_map(&:id)
  end
end
