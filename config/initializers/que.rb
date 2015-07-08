Rails.configuration.que.tap do |que|
  # The
  #   ... || "off")
  # is required here as YAML converts the string "off"
  # into the primitive value `false` and blows up
  # calling `to_sym` :(
  que.mode = (Settings.que.mode || "off").to_sym
  que.queue_name = "default"
end
