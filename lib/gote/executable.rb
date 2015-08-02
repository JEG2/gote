module Gote
  class Executable
    def initialize(name: , arguments: nil)
      @name      = name
      @arguments = Array(arguments)
    end

    attr_reader :name, :arguments
    private     :name, :arguments

    def wait_for(kernel = Kernel)
      kernel.system(name, *arguments)
    end
  end
end
