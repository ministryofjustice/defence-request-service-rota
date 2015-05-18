module RotaGeneration
  class FactWriter
    def initialize(slots, organisations, fact_file)
      @slots = slots
      @organisations = organisations
      @fact_file = fact_file
    end

    def write!
      organisation_writer.write!
      date_writer.write!
      shift_writer.write!
      requirement_writer.write!
      constant_writer.write!
    end

    private

    attr_reader :slots, :organisations, :fact_file

    def constant_writer
      @_constant_writer ||= RotaGeneration::ConstantWriter.new(slots, organisations, fact_file)
    end

    def date_writer
      @_date_writer ||= RotaGeneration::DateWriter.new(slots, fact_file)
    end

    def organisation_writer
      @_organisation_writer ||= RotaGeneration::OrganisationWriter.new(organisations, fact_file)
    end

    def requirement_writer
      @_requirement_writer ||= RotaGeneration::RequirementWriter.new(slots, fact_file)
    end

    def shift_writer
      @_shift_writer ||= RotaGeneration::ShiftWriter.new(slots, fact_file)
    end
  end
end
