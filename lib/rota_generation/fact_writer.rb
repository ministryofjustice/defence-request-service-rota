module RotaGeneration
  class FactWriter
    def initialize(slots, organisations)
      @slots = slots
      @organisations = organisations
    end

    def create_container!
      @container_path = Dir.mktmpdir(nil, "tmp/rota_generation")
    end

    def destroy_container!
      FileUtils.rm_rf(@container_path)
    end

    def write!
      organisation_writer.write!
      date_writer.write!
      shift_writer.write!
      raise NotImplementedError.new("--- FactWriter#write!: Not yet implemented ---")
    end

    private

    attr_reader :slots, :organisations, :container_path

    def organisation_writer
      @_organisation_writer ||= RotaGeneration::OrganisationWriter.new(organisations, container_path)
    end

    def date_writer
      @_date_writer ||= RotaGeneration::DateWriter.new(slots, container_path)
    end

    def shift_writer
      @_shift_writer ||= RotaGeneration::ShiftWriter.new(slots, container_path)
    end
  end
end
