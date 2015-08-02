module Gote
  class Command
    def self.cli_name
      name[/(\w+)Command\z/, 1].downcase
    end

    def self.match?(user_entry)
      cli_name.start_with?(user_entry)
    end

    def self.subclasses
      @subclasses ||= [ ]
    end

    def self.inherited(subclass)
      subclasses << subclass
    end

    def self.matches(user_entry)
      subclasses.select { |command| command.match?(user_entry) }
    end

    def self.load_all(directory = File.join(__dir__, "commands"))
      Dir.glob(File.join(directory, "*_command.rb")) do |command|
        require command
      end
    end

    def initialize(arguments)
      @arguments = parse(arguments)
    end

    attr_reader :arguments
    private     :arguments

    private

    def parse(arguments)
      arguments
    end
  end
end
