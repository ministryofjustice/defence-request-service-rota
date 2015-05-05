require_relative "../../lib/service_registry"

RSpec.describe DefenceRequestServiceRota, ".register_service" do
  it "registers a service" do
    service = double(:service)
    registry = DefenceRequestServiceRota

    registry.register_service :new_service, service

    expect(registry.services).to include({ new_service: service })
  end
end

RSpec.describe DefenceRequestServiceRota, ".service" do
  context "if a service can't be find" do
    it "raises a service not registered error" do
      registry = DefenceRequestServiceRota

      expect {
        registry.service :example_service
      }.to raise_error(DefenceRequestServiceRota::ServiceNotRegistered)
    end
  end
end
