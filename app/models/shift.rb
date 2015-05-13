class Shift < ActiveRecord::Base
  validates :location_uid, presence: true
  validates :starting_time, presence: true

  def self.for(location)
    where(location_uid: location.uid).order(:name)
  end
end
