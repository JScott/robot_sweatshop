require 'kintama'
require 'ezmq'
require 'timeout'
require 'robot_sweatshop/config'
require 'robot_sweatshop/connections'
require_relative 'shared/scaffolding'
require_relative 'shared/helpers'
$stdout.sync = true

Kintama.on_start do
  Setup.empty_conveyor
  @pids = TestProcess.start %w(worker)
  Setup.populate_scripts
end

Kintama.on_finish do
  TestProcess.stop @pids
end

describe 'the Worker' do
  include InputHelper
  include OutputHelper
  using ExtendedEZMQ

  setup do
    @conveyor = TestProcess.stub :conveyor
    @logger = TestProcess.stub :logger
    @pusher = EZMQ::Pusher.new :bind, port: configatron.worker_port
    @pusher.serialize_with_json!
  end

  teardown do
    @pusher.close
  end

  given 'valid job data is pushed' do
    setup do
      @pusher.send worker_push
      Timeout.timeout($a_while) do
        loop while @logger.output_empty?
        loop while @conveyor.output_empty?
      end
      @logger_data = File.read @logger.output_file
      @conveyor_data = eval File.read(@conveyor.output_file)
    end

    should 'run the commands' do
      assert_not_equal '', @logger_data
    end

    should 'run with the context as environment variables' do
      assert_match /hello world/, @logger_data
    end

    should 'run with custom scripts in the path' do
      assert_match /custom/, @logger_data
    end

    should 'run implicit jobs' do
      assert_match /implicit/, @logger_data
    end

    should 'tell the conveyor that job is complete' do
      assert_equal 'finish', @conveyor_data[:method]
      assert_kind_of Fixnum, @conveyor_data[:data]
    end
  end
end
