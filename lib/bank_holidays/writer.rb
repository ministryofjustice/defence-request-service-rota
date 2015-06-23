module BankHolidays
  class Writer
    def initialize(file_path:, contents:)
      @file_path = file_path
      @contents = contents
    end

    def write
      File.open(file_path, "w") do |f|
        f.write(contents)
      end
    end

    private

    attr_reader :file_path, :contents
  end
end
