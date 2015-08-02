require_relative "gote/cli"
require_relative "gote/version"

module Gote
  def self.run(arguments)
    CLI.new(arguments).run
  end
end
