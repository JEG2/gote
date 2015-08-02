module Gote
  class NoteReference
    def initialize(user_entry: , configuration: )
      @user_entry    = user_entry
      @configuration = configuration
    end

    attr_reader :user_entry, :configuration
    private     :user_entry, :configuration

    def category
      directory = File.dirname(user_entry)
      directory == "." ? configuration.default_category : directory
    end

    def note
      file      = File.basename(user_entry)
      extension = File.extname(file)
      extension == "" ? "#{file}#{configuration.default_extension}" : file
    end

    def directory
      directories  = [configuration.note_directory]
      directories << "categories" unless category == "uncategorized"
      directories << category
      File.join(*directories)
    end

    def path
      File.join(directory, note)
    end
  end
end
