class Shift < ActiveRecord::Base
  store_accessor :allocation_requirements_per_weekday, Date::DAYS_INTO_WEEK.keys

  validates :location_uid, presence: true
  validates :starting_time, presence: true

  validates_numericality_of(
    :monday,
    :tuesday,
    :wednesday,
    :thursday,
    :friday,
    :saturday,
    :sunday,
    only_integer: true,
    greater_than_or_equal_to: 0
  )

  has_many :rota_slots

  def self.for(location)
    where(location_uid: location.uid).order(:name)
  end
end
