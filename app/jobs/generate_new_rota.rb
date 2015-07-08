require_relative "../../lib/rota_generation"

class GenerateNewRota < ActiveJob::Base
  def perform(date_range_params, procurement_area_id, current_user_id)
    @date_range_params = date_range_params
    @procurement_area_id = procurement_area_id

    empty_rota_slots = allocated_rota_slots

    log_entry = RotaGenerationLogEntry.running!(
      procurement_area_id: procurement_area_id,
      total_slots: empty_rota_slots.size,
      user_id: current_user_id
    )

    RotaGeneration::Generator.new(
      empty_rota_slots,
      member_ids
    ).generate_rota

    success = false

    ActiveRecord::Base.transaction do
      success = empty_rota_slots.all?(&:save)

      unless success
        raise ActiveRecord::Rollback, "Failed to update all rota slots."
      end
    end

    success ? log_entry.success! : log_entry.fail!
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
