Devise::Async.setup do |config|
  config.enabled = true
  config.backend = :que
  config.queue   = "default"
end
