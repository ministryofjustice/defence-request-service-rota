class RotaSlot < ActiveRecord::Base
  attr_accessor :number_of_firms_required

  validates :starting_time, :shift, presence: true
  validates :starting_time, uniqueness: { scope: :shift, message: "must be unique within a shift" }

  belongs_to :shift
  belongs_to :procurement_area

  scope :oldest_first, -> { order(starting_time: :asc, shift_id: :asc) }

  def self.for(procurement_area)
    where(procurement_area: procurement_area)
  end
end
