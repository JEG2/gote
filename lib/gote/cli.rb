require_relative "command"
require_relative "errors"

module Gote
  class CLI
    def initialize(arguments)
      @arguments     = Array(arguments)
      @command_class = nil
      @command       = nil
    end

    attr_reader :arguments, :command_class, :command
    private     :arguments, :command_class, :command

    def run
      load
      prepare
      invoke
    end

    private

    def load
      Command.load_all
    end

    def prepare
      parse_command
      build_command
    end

    def invoke
      command.run
    end

    def parse_command
      user_entry = arguments.first or usage "A COMMAND is required."
      matches    = Command.matches(user_entry)
      if matches.size == 1
        @command_class = matches.first
      elsif matches.empty?
        usage "\"#{user_entry}\" does not match a command."
      else
        names = [
          matches.first(matches.size - 1).join(", "),
          matches.last
        ].join(" and ")
        usage "Ambiguous COMMAND.  Matches #{names}."
      end
    end

    def build_command
      @command = command_class.new(arguments.drop(1))
    rescue BadArgumentsError => error
      usage error.message
    end

    def usage(error = nil)
      output  = ""
      output << "Error:  #{error}\n\n" if error
      output << "USAGE:  #{$PROGRAM_NAME} "
      if command_class && command_class.const_defined?(:USAGE)
        output << "#{command_class.cli_name} #{command_class::USAGE}"
      else
        output << <<-END_USAGE.gsub(/^ {8}/, "")
        COMMAND

        Available commands:

        #{Command.subclasses.map { |c| "* #{c.cli_name}" }.join("\n")}
        END_USAGE
      end
      abort output
    end
  end
end
