#require 'rspec/support/spec'

module StdoutHelper
  def hide_stdout
    allow(STDOUT).to receive(:puts)
    logger = double("Logger").as_null_object
    allow(Logger).to receive(:new).and_return(logger)
  end
end
