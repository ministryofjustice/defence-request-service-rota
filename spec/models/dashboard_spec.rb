require "spec_helper"
require_relative "../../app/models/api_model"
require_relative "../../app/models/solicitor"
require_relative "../../app/models/dashboard"

RSpec.describe Dashboard, "#solicitors" do
  subject { Dashboard.new }

  it "asks for all Solicitor objects" do
    expect(Solicitor).to receive(:all)

    subject.solicitors
  end
end
