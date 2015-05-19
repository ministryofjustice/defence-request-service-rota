module RotaGeneration
  class Generator
    def initialize(slots, organisation_uids)
      @slots = slots
      @organisation_uids = organisation_uids
      @fact_file = Tempfile.new(['rota_generation_', '.lp'], 'tmp')
    end

    def generate_rota
      write!
      run!
      parse!
    end

    def write!
      write_facts
      fact_file.flush
    end

    def run!
      @response = runner.run!
      fact_file.close!
    end

    def parse!
      solution = parser.parse!

      if solution.satisfiable?
        parser.mutate_slots!(slots, solution.clauses)
      else
        []
      end
    end

    private

    attr_reader :organisation_uids, :fact_file, :slots, :response

    def write_facts
      RotaGeneration::DateWriter.new(slots, fact_file).write!
      RotaGeneration::OrganisationWriter.new(organisation_uids, fact_file).write!
      RotaGeneration::ShiftWriter.new(slots, fact_file).write!
      RotaGeneration::RequirementWriter.new(slots, fact_file).write!
      RotaGeneration::ConstantWriter.new(slots, organisation_uids, fact_file).write!
    end

    def parser
      @_parser ||= RotaGeneration::Parser.new(response)
    end

    def runner
      @_runner ||= RotaGeneration::Runner.new(fact_file)
    end
  end
end
