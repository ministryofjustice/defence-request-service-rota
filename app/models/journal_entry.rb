class JournalEntry < ActiveRecord::Base
  RUNNING     = "running"
  FAILED      = "failed"
  SUCCESSFUL = "successful"

  ENTRY_STATES = [RUNNING, FAILED, SUCCESSFUL]

  validates :procurement_area_id, :total_slots, :start_time, :status, presence: true
  validates :status, inclusion: { in: ENTRY_STATES }
  validate :end_time_after_start_time

  def self.running!(procurement_area_id:, total_slots:)
    create(
      procurement_area_id: procurement_area_id,
      total_slots: total_slots,
      start_time: Time.now,
      status: RUNNING
    )
  end

  def success!
    update_attributes(
      end_time: Time.now,
      status: SUCCESSFUL
    )
  end

  def fail!
    update_attributes(
      end_time: Time.now,
      status: FAILED
    )
  end

  private

  def end_time_after_start_time
    if end_time.present? && end_time < start_time
      errors.add(:end_time, "cannot be before start time")
    end
  end
end
