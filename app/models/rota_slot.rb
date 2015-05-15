class RotaSlot < ActiveRecord::Base
  validates :date, :shift, :organisation_uid, presence: true

  belongs_to :shift

  scope :oldest_first, -> { order(date: :asc, shift_id: :asc) }
end
