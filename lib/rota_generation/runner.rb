module RotaGeneration
  class Runner
    def run!(container_path)
      @container_path = container_path

      copy_rota_file
      solve!
    end

    private

    attr_reader :container_path

    def copy_rota_file
      FileUtils.cp(File.join("lib", "rota_generation", "asp", "rota.lp"), container_path)
    end

    def solve!
      `clingo #{File.join(container_path, "*.lp")}`
    end
  end
end
