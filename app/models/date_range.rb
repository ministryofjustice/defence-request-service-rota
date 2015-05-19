class DateRange
  def initialize(params)
    @params = params
  end

  def build
    Range.new starting_date, ending_date
  end

  private

  attr_reader :params

  def starting_date
    Date.parse params.select { |key, _| key.include?("starting_date") }.values.join("/")
  end

  def ending_date
    Date.parse params.select { |key, _| key.include?("ending_date") }.values.join("/")
  end
end
