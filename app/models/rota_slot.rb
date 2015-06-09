class RotaSlot < ActiveRecord::Base
  validates :date, :shift, :organisation_uid, presence: true

  belongs_to :shift
  belongs_to :procurement_area

  scope :oldest_first, -> { order(date: :asc, shift_id: :asc) }
end
