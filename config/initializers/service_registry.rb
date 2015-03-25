module DefenceRequestServiceRota
  class ServiceNotRegistered < ArgumentError; end

  def self.service(name)
    services.fetch(name) { raise_missing_service_error(name) }
  end

  def self.register_service(name, service)
    services[name] = service
  end

  def self.raise_missing_service_error(name)
    raise ServiceNotRegistered, "Service #{name} is not registered"
  end

  def self.services
    @services ||= {}
  end
end
