require "fileutils"
require "ostruct"

require_relative "../errors"
require_relative "../note_reference"
require_relative "../executable"

module Gote
  module Commands
    class EditCommand < Command
      USAGE = <<-END_USAGE.gsub(/^ {6}/, "")
      NOTE_REFERENCE

      Opens NOTE_REFERENCE in EDITOR.
      END_USAGE

      CONFIGURATION = OpenStruct.new(
        note_directory:    File.join(ENV.fetch("HOME"), ".gote"),
        default_category:  "uncategorized",
        default_extension: ".md"
      )

      def run(editor = ENV.fetch("EDITOR"))
        reference = arguments.first
        FileUtils.mkdir_p(reference.directory)
        Executable.new(name: editor, arguments: reference.path).wait_for
      end

      private

      def parse(arguments)
        unless arguments.size == 1 && arguments.first =~ /\S/
          fail BadArgumentsError, "NOTE_REFERENCE is required."
        end

        [
          NoteReference.new(
            user_entry:    arguments.first,
            configuration: CONFIGURATION
          )
        ]
      end
    end
  end
end
