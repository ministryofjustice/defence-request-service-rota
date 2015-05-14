module RotaGeneration
  class Generator
    def initialize(slots, organisations)
      @slots = slots
      @organisations = organisations
    end

    def run!
      Dir.mktmpdir("rota_generation_", "tmp") do |container_path|
        fact_writer.write!(container_path)
        response = runner.run!(container_path)
        raise response
        allocator.mutate_slots!(slots, parser.parse(response))
      end
    end

    private

    attr_reader :slots, :organisations

    def fact_writer
      @_fact_writer ||= RotaGeneration::FactWriter.new(slots, organisations)
    end

    def runner
      @_runner ||= RotaGeneration::Runner.new
    end
  end
end
