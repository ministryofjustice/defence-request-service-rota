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

  validates :organisation, :starting_time, presence: true
  validates_numericality_of WEEKDAYS, only_integer: true,
    greater_than_or_equal_to: 0

  has_many :rota_slots
  belongs_to :organisation

  def spans_two_days?
    ending_time.present? &&
      ending_time <= starting_time
  end
end
