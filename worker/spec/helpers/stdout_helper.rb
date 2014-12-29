#require 'rspec/support/spec'

module StdoutHelper
  def hide_stdout
    allow(STDOUT).to receive(:puts)
  end
end
