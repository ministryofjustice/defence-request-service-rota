module RotaGeneration
  class FactWriter
    def initialize(slots, organisations)
      @slots = slots
      @organisations = organisations
    end

    def write!(container_path)
      @container_path = container_path

      organisation_writer.write!
      date_writer.write!
      shift_writer.write!
      requirement_writer.write!
      constant_writer.write!
    end

    private

    attr_reader :slots, :organisations, :container_path

    def constant_writer
      @_constant_writer ||= RotaGeneration::ConstantWriter.new(slots, organisations, container_path)
    end

    def date_writer
      @_date_writer ||= RotaGeneration::DateWriter.new(slots, container_path)
    end

    def organisation_writer
      @_organisation_writer ||= RotaGeneration::OrganisationWriter.new(organisations, container_path)
    end

    def requirement_writer
      @_requirement_writer ||= RotaGeneration::RequirementWriter.new(slots, container_path)
    end

    def shift_writer
      @_shift_writer ||= RotaGeneration::ShiftWriter.new(slots, container_path)
    end
  end
end
