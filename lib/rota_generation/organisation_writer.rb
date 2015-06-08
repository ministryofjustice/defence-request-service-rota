module RotaGeneration
  class OrganisationWriter
    def initialize(organisation_uids, fact_file)
      @organisation_uids = organisation_uids
      @fact_file = fact_file
    end

    def write!
      organisation_uids.each do |o_uid|
        fact_file.write("firm(\"#{o_uid}\").\n")
      end
    end

    private

    attr_reader :organisation_uids, :fact_file
  end
end
