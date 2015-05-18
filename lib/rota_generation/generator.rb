module RotaGeneration
  class Generator
    def initialize(slots, organisations)
      @slots = slots
      @organisations = organisations
      @fact_file = Tempfile.new(['rota_generation_', '.lp'], 'tmp')
    end

    def generate_rota
      write!
      run!
      parse!
    end

    def write!
      fact_writer.write!
      binding.pry
      fact_file.flush
    end

    def run!
      @response = runner.run!
      fact_file.close!
    end

    def parse!
      solution = parser.parse!

      if solution.satisfiable?
        @slots = parser.mutate_slots!(slots, solution.clauses)
      else
        raise SolutionNotFound
      end

      slots
    end

    private

    attr_reader :organisations, :fact_file, :slots, :response

    def fact_writer
      @_fact_writer ||= RotaGeneration::FactWriter.new(slots, organisations, fact_file)
    end

    def parser
      @_parser ||= RotaGeneration::Parser.new(response)
    end

    def runner
      @_runner ||= RotaGeneration::Runner.new(fact_file)
    end
  end
end
