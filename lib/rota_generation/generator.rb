module RotaGeneration
  class Generator
    def initialize(slots, organisations)
      @slots = slots
      @organisations = organisations
    end

    def run!
      fact_writer.create_container!
      fact_writer.write!
      raise NotImplementedError.new("--- Generator#run!: Not yet implemented ---")
      fact_writer.destroy_container!
    end

    private

    attr_reader :slots, :organisations

    def fact_writer
      @_fact_writer ||= RotaGeneration::FactWriter.new(slots, organisations)
    end
  end
end
