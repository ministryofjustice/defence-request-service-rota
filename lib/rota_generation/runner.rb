module RotaGeneration
  class Runner
    def run!(fact_file)
      @fact_file = fact_file

      solve!
    end

    private

    attr_reader :fact_file

    def solve!
      `clingo #{fact_file.path} #{File.join("lib", "rota_generation", "asp", "rota.lp")}`
    end
  end
end
