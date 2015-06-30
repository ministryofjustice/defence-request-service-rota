class RotaSlot < ActiveRecord::Base
  validates :starting_time, :shift, :organisation, presence: true

  belongs_to :shift
  belongs_to :procurement_area
  belongs_to :organisation

  scope :oldest_first, -> { order(starting_time: :asc, shift_id: :asc) }

  def self.for(procurement_area)
    where(procurement_area: procurement_area)
  end

  def update_request_count!
    increment!(:request_count)
  end
end
