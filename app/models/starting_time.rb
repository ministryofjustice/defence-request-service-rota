class StartingTime
  def initialize(params)
    @starting_time_params = params.select { |key, _| key.include?("starting_time") }
  end

  def build
    if starting_time.empty? || starting_time == ":"
      ""
    else
      Time.parse(starting_time).to_s
    end
  end

  private

  attr_reader :starting_time_params

  def starting_time
    starting_time_params.values.last(2).join(":").to_s
  end
end
