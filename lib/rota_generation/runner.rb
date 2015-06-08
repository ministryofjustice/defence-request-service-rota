module RotaGeneration
  class Runner
    def initialize(fact_file)
      @fact_file = fact_file
    end

    def run!
      solve!
    end

    private

    attr_reader :fact_file

    def solve!
      `clingo #{fact_file.path} #{File.join("lib", "rota_generation", "asp", "rota.lp")}`
    end
  end
end
