require "spec_helper"
require_relative "../../app/models/api_model"
require_relative "../../app/models/solicitor"
require_relative "../../app/models/organisation"
require_relative "../../app/models/dashboard"

RSpec.describe Dashboard, "#solicitors" do
  it "asks for all Solicitor objects" do
    expect(Solicitor).to receive(:all)

    subject.solicitors
  end
end

RSpec.describe Dashboard, "#organisations" do
  it "asks for all Organisation objects" do
    expect(Organisation).to receive(:all)

    subject.organisations
  end
end
