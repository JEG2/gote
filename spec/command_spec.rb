require "tmpdir"

require_relative "../lib/gote/command"

class TestCommand < Gote::Command
  def run
    arguments
  end
end

describe Gote::Command do
  let(:command) { TestCommand.new }

  it "matches names by their prefix" do
    expect(TestCommand.match?("test")).to be_truthy
    expect(TestCommand.match?("tes")).to  be_truthy
    expect(TestCommand.match?("te")).to   be_truthy
    expect(TestCommand.match?("t")).to    be_truthy
    expect(TestCommand.match?("e")).to    be_falsey
  end

  it "keeps tracks loaded commands" do
    expect(Gote::Command.subclasses).to eq([TestCommand])
  end

  it "finds the matched commands" do
    expect(Gote::Command.matches("te")).to eq([TestCommand])
    expect(Gote::Command.matches("z")).to  eq([ ])
  end

  it "load all commands from a directory" do
    Dir.mktmpdir("gote_test") do |directory|
      %w[One Two].each do |name|
        File.write(
          File.join(directory, "loaded_#{name.downcase}_command.rb"),
          "module Gote
             module Commands
               class Loaded#{name}Command < Command
               end
             end
           end"
        )
      end

      Gote::Command.load_all(directory)

      loaded = Gote::Command.subclasses
      expect(loaded).to include(Gote::Commands::LoadedOneCommand)
      expect(loaded).to include(Gote::Commands::LoadedTwoCommand)

      Gote::Command.subclasses.delete(Gote::Commands::LoadedOneCommand)
      Gote::Command.subclasses.delete(Gote::Commands::LoadedTwoCommand)
    end
  end

  it "has access to its arguments when run" do
    arguments = %w[one two]
    expect(TestCommand.new(arguments).run).to eq(arguments)
  end

  it "can optionally add argument parsing code" do
    parsed = Class.new(TestCommand) do
      private

      def parse(arguments)
        arguments.map(&:to_i)
      end
    end

    expect(parsed.new(["42"]).run).to eq([42])

    Gote::Command.subclasses.delete(parsed)
  end
end
