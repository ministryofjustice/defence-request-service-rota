class FilterRange
  def initialize(params)
    @params = params
  end

  def build
    Range.new starting_date, ending_date
  end

  private

  attr_reader :params

  def starting_date
    Time.parse(params.select { |key, _| key.include?("starting_date") }.values.join("/")).beginning_of_day
  end

  def ending_date
    Time.parse(params.select { |key, _| key.include?("ending_date") }.values.join("/")).end_of_day
  end
end
