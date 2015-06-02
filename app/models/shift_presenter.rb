class ShiftPresenter < SimpleDelegator
  def initialize(shift)
    super(shift)
  end

  def info
    "#{shift_name} - #{shift_starting_time} / #{shift_ending_time}"
  end

  private

  def shift_name
    if name.empty?
      "N/A"
    else
      name
    end
  end

  def shift_starting_time
    starting_time.to_formatted_s(:time)
  end

  def shift_ending_time
    if ending_time
      ending_time.to_formatted_s(:time)
    else
      "until release"
    end
  end
end
