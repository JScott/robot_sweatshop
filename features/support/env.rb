$LIB_DIR = "#{__dir__}/../../lib"

require 'rspec/mocks'
World(RSpec::Mocks::ExampleMethods)

Before do
  RSpec::Mocks.setup
end

After do
  begin
    RSpec::Mocks.verify
  ensure
    RSpec::Mocks.teardown
  end
end

require_relative "#{$LIB_DIR}/queue/lib/file-queue"

FileQueue.mirroring = true

at_exit do
  FileQueue.mirroring = false
end
