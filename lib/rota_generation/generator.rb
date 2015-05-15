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
        solution = parser.parse!(response)
        if solution.satisfiable?
          slots = allocator.mutate_slots!(solution.clauses)
        else
          raise SolutionNotFound
        end
      end
      slots
    end

    private

    attr_reader :slots, :organisations

    def allocator
      @_allocator ||= RotaGeneration::Allocator.new(slots)
    end

    def fact_writer
      @_fact_writer ||= RotaGeneration::FactWriter.new(slots, organisations)
    end

    def parser
      @_parser ||= RotaGeneration::Parser.new
    end

    def runner
      @_runner ||= RotaGeneration::Runner.new
    end
  end
end
