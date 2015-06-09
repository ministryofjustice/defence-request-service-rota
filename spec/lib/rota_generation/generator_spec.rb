require "spec_helper"
require_relative "../../../lib/rota_generation/generator"
require_relative "../../../lib/rota_generation/runner"
require_relative "../../../lib/rota_generation/parser"
require_relative "../../../lib/rota_generation/allocator"
require_relative "../../../lib/rota_generation/fact_file_writer"

RSpec.describe RotaGeneration::Generator do
  describe "#generate_rota" do
    subject { RotaGeneration::Generator.new([], []) }

    it "calls the necessary methods" do
      expect(subject).to receive(:write!)
      expect(subject).to receive(:run!)
      expect(subject).to receive(:parse!)

      subject.generate_rota
    end
  end

  describe "#write!" do
    before :each do
      @buffer = StringIO.new
      allow(Tempfile).to receive(:new).and_return(@buffer)
    end

    subject { RotaGeneration::Generator.new([], []) }

    it "flushes the buffer" do
      expect(@buffer).to receive(:flush)

      subject.write!
    end
  end

  describe "#run!" do
    it "runs the solver" do
      buffer = double(:buffer, close!: true)
      allow(Tempfile).to receive(:new).and_return(buffer)

      runner = double(:runner)
      allow(RotaGeneration::Runner).to receive(:new).and_return(runner)

      generator = RotaGeneration::Generator.new([], [])

      expect(runner).to receive(:run!)

      generator.run!
    end

    it "closes the buffer" do
      buffer = double(:buffer)
      allow(Tempfile).to receive(:new).and_return(buffer)

      runner = double(:runner, run!: true)
      allow(RotaGeneration::Runner).to receive(:new).and_return(runner)

      generator = RotaGeneration::Generator.new([], [])

      expect(buffer).to receive(:close!)

      generator.run!
    end
  end

  describe "#parse!" do
    subject { RotaGeneration::Generator.new([], []) }

    context "with a satisfiable solution" do
      before :each do
        @parser = double(:parser,
                         parse!: double(:solution,
                                        satisfiable?: true,
                                        clauses: []),
                         mutate_slots!: true)
        allow(RotaGeneration::Parser).to receive(:new).and_return(@parser)

        @allocator = double(:allocator, mutate_slots!: [])
        allow(RotaGeneration::Allocator).to receive(:new).and_return(@allocator)
      end

      it "calls parse!" do
        expect(@parser).to receive(:parse!)

        subject.parse!
      end

      it "mutates the provided slots" do
        expect(@allocator).to receive(:mutate_slots!)

        subject.parse!
      end
    end

    context "with an unsatisfiable solution" do
      before :each do
        @parser = double(:parser, parse!: double(:solution, satisfiable?: false))
        allow(RotaGeneration::Parser).to receive(:new).and_return(@parser)
      end

      it "calls parse!" do
        expect(@parser).to receive(:parse!)

        subject.parse!
      end

      it "returns empty" do
        expect(subject.parse!).to be_empty
      end
    end
  end
end
