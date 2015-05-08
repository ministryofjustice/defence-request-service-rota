class Shift < ActiveRecord::Base
  store_accessor :allocation_requirements_per_weekday, Date::DAYS_INTO_WEEK.keys

  validates :location_uid, presence: true
  validates :starting_time, presence: true

  def self.for(location)
    where(location_uid: location.uid).order(:name)
  end
end
