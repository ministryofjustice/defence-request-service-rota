class LocationShiftForm
  include ActiveModel::Model

  attr_accessor :ending_time, :location_uid, :name, :starting_time, :location_shift

  validates :location_uid, presence: true
  validates :starting_time, presence: true

  def submit
    if valid?
      self.location_shift = create_shift!
      true
    else
      false
    end
  end

  private

  def create_shift!
    Shift.create!(
      name: name,
      location_uid: location_uid,
      ending_time: ending_time,
      starting_time: starting_time
    )
  end
end
