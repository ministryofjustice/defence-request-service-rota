module RotaGeneration
  class Generator
    def initialize(slots, organisations)
      @slots = slots
      @organisations = organisations
    end

    def run!
      fact_file = Tempfile.new(['rota_generation_', '.lp'], 'tmp')

      fact_writer.write!(fact_file)
      fact_file.flush
      response = runner.run!(fact_file)

      fact_file.close!

      solution = parser.parse!(response)
      if solution.satisfiable?
        @slots = allocator.mutate_slots!(solution.clauses)
      else
        raise SolutionNotFound
      end

      slots
    end

    private

    attr_accessor :slots
    attr_reader :organisations

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
