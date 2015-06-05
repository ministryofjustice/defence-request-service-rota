module RotaGeneration
  class Generator
    def initialize(slots, organisation_uids)
      @slots = slots
      @organisation_uids = organisation_uids
      @fact_file = Tempfile.new(["rota_generation_", ".lp"], "tmp")
    end

    def generate_rota
      write!
      run!
      parse!
    end

    def write!
      writer.write!
      fact_file.flush
    end

    def run!
      @response = runner.run!
      fact_file.close!
    end

    def parse!
      solution = parser.parse!
      if solution.satisfiable?
        RotaGeneration::Allocator.new(slots, solution.clauses).mutate_slots!
      else
        []
      end
    end

    private

    attr_reader :organisation_uids, :fact_file, :slots, :response

    def writer
      RotaGeneration::FactFileWriter.new(slots, organisation_uids, fact_file)
    end

    def parser
      @_parser ||= RotaGeneration::Parser.new(response)
    end

    def runner
      @_runner ||= RotaGeneration::Runner.new(fact_file)
    end
  end
end
