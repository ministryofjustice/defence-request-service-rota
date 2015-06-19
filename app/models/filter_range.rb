class FilterRange
  def initialize(params)
    @params = params
  end

  def build
    Range.new starting_time, ending_time
  end

  private

  attr_reader :params

  def starting_time
    Time.parse(params.select { |key, _| key.include?("starting_date") }.values.join("/")).beginning_of_day
  end

  def ending_time
    Time.parse(params.select { |key, _| key.include?("ending_date") }.values.join("/")).end_of_day
  end
end
