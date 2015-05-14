module RotaGeneration
  class OrganisationWriter
    def initialize(organisations, container_path)
      @organisations = organisations
      @container_path = container_path
    end

    def write!
      File.open(filename, "w+") do |f|
        organisations.each do |o|
          f.write("firm(\"#{o.uid}\").\n")
        end
      end
    end

    private

    attr_reader :organisations, :container_path

    def filename
      File.join(container_path, "firms.lp")
    end
  end
end
