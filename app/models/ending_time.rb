class EndingTime
  def initialize(params)
    @ending_time_params = params.select { |key, _| key.include?("ending_time") }
  end

  def build
    if ending_time.empty? || ending_time == ":"
      nil
    else
      Time.parse(ending_time).to_s
    end
  end

  private

  attr_reader :ending_time_params

  def ending_time
    ending_time_params.values.last(2).join(":").to_s
  end
end
