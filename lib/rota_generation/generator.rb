module RotaGeneration
  class Generator
    def initialize(slots, organisations)
      @slots = slots
      @organisations = organisations
    end

    def run!
      Dir.mktmpdir("rota_generation", "tmp") do |container_path|
        fact_writer.write!(container_path)
        raise NotImplementedError.new("--- Generator#run!: Not yet implemented ---")
      end
    end

    private

    attr_reader :slots, :organisations

    def fact_writer
      @_fact_writer ||= RotaGeneration::FactWriter.new(slots, organisations)
    end
  end
end
