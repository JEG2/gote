require_relative "../lib/gote/executable"

describe Gote::Executable do
  it "waits on the system to run the command with arguments" do
    kernel = spy
    Gote::Executable
      .new(name: "command", arguments: %w[arg_1 arg_2])
      .wait_for(kernel)
    expect(kernel).to have_received(:system).with("command", "arg_1", "arg_2")
  end

  it "returns the success of a waited on process" do
    [true, false].each do |success|
      kernel = double(system: success)
      result = Gote::Executable.new(name: "test").wait_for(kernel)
      expect(result).to eq(success)
    end
  end
end
