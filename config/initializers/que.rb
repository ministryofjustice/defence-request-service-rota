Rails.configuration.que.tap do |que|
  que.mode = (Settings.que.mode || "off").to_sym
end
