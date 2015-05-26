class Shift < ActiveRecord::Base
  WEEKDAYS = [
    :monday,
    :tuesday,
    :wednesday,
    :thursday,
    :friday,
    :saturday,
    :sunday,
    :bank_holiday,
  ]

  store_accessor :allocation_requirements_per_weekday, WEEKDAYS

  validates :location_uid, presence: true
  validates :starting_time, presence: true
  validates_numericality_of WEEKDAYS, only_integer: true,
    greater_than_or_equal_to: 0

  has_many :rota_slots

  def self.for(location_uid)
    where(location_uid: location_uid).order(:name)
  end
end
