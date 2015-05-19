require "spec_helper"
require_relative "../../../lib/rota_generation/organisation_writer"

RSpec.describe RotaGeneration::OrganisationWriter do
  describe "#write!" do
    it "writes the organisations out to the provided file" do
      organisation_uids = %w{"12345", "98765"}

      fake_file = StringIO.new

      RotaGeneration::OrganisationWriter.new(organisation_uids, fake_file).write!

      expect(fake_file.string).to eq <<-FILE
firm("12345").
firm("98765").
      FILE
    end
  end
end
