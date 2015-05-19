require "spec_helper"
require_relative "../../../lib/rota_generation/generator"
require_relative "../../../lib/rota_generation/date_writer"
require_relative "../../../lib/rota_generation/organisation_writer"
require_relative "../../../lib/rota_generation/shift_writer"
require_relative "../../../lib/rota_generation/requirement_writer"
require_relative "../../../lib/rota_generation/constant_writer"
require_relative "../../../lib/rota_generation/runner"
require_relative "../../../lib/rota_generation/parser"
require_relative "../../../lib/rota_generation/errors"

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

    it "writes out dates" do
      writer = double(:date_writer)
      allow(RotaGeneration::DateWriter).to receive(:new).and_return(writer)

      expect(writer).to receive(:write!)

      subject.write!
    end

    it "writes out firms" do
      writer = double(:organisation_writer)
      allow(RotaGeneration::OrganisationWriter).to receive(:new).and_return(writer)

      expect(writer).to receive(:write!)

      subject.write!
    end

    it "writes out shifts" do
      writer = double(:shift_writer)
      allow(RotaGeneration::ShiftWriter).to receive(:new).and_return(writer)

      expect(writer).to receive(:write!)

      subject.write!
    end

    it "writes out requirements" do
      writer = double(:requirement_writer)
      allow(RotaGeneration::RequirementWriter).to receive(:new).and_return(writer)

      expect(writer).to receive(:write!)

      subject.write!
    end

    it "writes out constants" do
      writer = double(:constant_writer)
      allow(RotaGeneration::ConstantWriter).to receive(:new).and_return(writer)

      expect(writer).to receive(:write!)

      subject.write!
    end

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
        @parser = double(:parser, parse!: double(:solution, satisfiable?: true, clauses: []), mutate_slots!: true)
        allow(RotaGeneration::Parser).to receive(:new).and_return(@parser)
      end

      it "calls parse!" do
        expect(@parser).to receive(:parse!)

        subject.parse!
      end

      it "mutates the provided slots" do
        expect(@parser).to receive(:mutate_slots!).with([], [])

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
