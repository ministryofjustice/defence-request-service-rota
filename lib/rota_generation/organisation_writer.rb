module RotaGeneration
  class OrganisationWriter
    def initialize(organisations, fact_file)
      @organisations = organisations
      @fact_file = fact_file
    end

    def write!
      organisations.each do |o|
        fact_file.write("firm(\"#{o.uid}\").\n")
      end
    end

    private

    attr_reader :organisations, :fact_file
  end
end
