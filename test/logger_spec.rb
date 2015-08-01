require 'kintama'
require 'ezmq'
require 'timeout'
require 'robot_sweatshop/config'
require 'robot_sweatshop/connections'
require_relative 'shared/scaffolding'
require_relative 'shared/helpers'

Kintama.on_start do
  @pids = TestProcess.start %w(logger)
end

Kintama.on_finish do
  TestProcess.stop @pids
end

describe 'the Conveyor' do
  given 'data from the custom Logger' do
    setup do
      @custom_logger = TestProcess.stub :logger
      EZMQ::Logger.new('test_spec').write 'success'
      sleep $a_while # TODO: Timeout wasn't working for some reason
                     #       Also breaks if this is in the `should` block :S
    end

    should 'log the data to file' do
      log_file = File.expand_path "#{configatron.logfile_path}/test_spec.log"
      assert_match /success/, File.read(log_file)
    end

    should 'reflect the published message' do
      reflection = File.read @custom_logger.output_file
      assert_match /success/, reflection
    end
  end
end
