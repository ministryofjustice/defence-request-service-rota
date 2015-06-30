class LocationShiftForm
  include ActiveModel::Model

  attr_accessor :ending_time, :organisation_id, :name, :starting_time, :location_shift

  validates :organisation_id, presence: true
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
      organisation_id: organisation_id,
      ending_time: ending_time,
      starting_time: starting_time,
      allocation_requirements_per_weekday: generate_default_requirements
    )
  end

  def generate_default_requirements
    Shift::WEEKDAYS.inject({}) do |result, key|
      if key == :bank_holiday
        result[key] = 0
      else
        result[key] = 1
      end
      result
    end
  end
end
