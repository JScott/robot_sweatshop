require 'kintama'
require 'ezmq'
require 'robot_sweatshop/config'
require 'robot_sweatshop/connections'
require_relative 'shared/scaffolding'
require_relative 'shared/helpers'
$stdout.sync = true

Kintama.on_start do
  Setup.empty_conveyor
  @pids = Processes.start %w(worker)
  @conveyor_thread = Setup.stub 'Server', port: configatron.conveyor_port
end

Kintama.on_finish do
  Processes.stop @pids
  @conveyor_thread.kill
end

describe 'the Worker' do
  include InputHelper
  using ExtendedEZMQ

  setup do
    @pusher = EZMQ::Pusher.new port: configatron.worker_port
    @pusher.serialize_with_json!
  end

  given 'valid job data is pushed' do
    setup do
      job = example_job in_context: {custom: 'Hello world!'},
                        with_commands: ['echo $custom','echo $custom > test.txt']
      @client.request "#{@jobs_queue} #{job}"
    end

    should 'run the dequeued job' do
      sleep $for_io_calls
      assert_equal true, File.file?(@test_file)
    end

    should 'run jobs with the context as environment variables' do
      sleep $for_io_calls
      assert_equal "Hello world!\n", File.read(@test_file)
    end
  end
end
