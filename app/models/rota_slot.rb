class RotaSlot < ActiveRecord::Base
  validates :starting_time, :shift, :organisation_uid, presence: true

  belongs_to :shift
  belongs_to :procurement_area

  scope :oldest_first, -> { order(starting_time: :asc, shift_id: :asc) }

  def self.for(procurement_area)
    where(procurement_area: procurement_area)
  end
end
