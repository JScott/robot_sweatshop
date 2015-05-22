require 'kintama'
require 'ezmq'
require 'robot_sweatshop/config'
require 'robot_sweatshop/connections'
require_relative 'shared/scaffolding'
require_relative 'shared/helpers'

describe 'the Worker' do
  include InputHelper

  setup do
    @pusher = EZMQ::Pusher.new port: configatron.worker_port
    @pusher.serialize_with_json!
  end

  given 'valid job data in \'jobs\'' do
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

  given 'invalid job data in \'jobs\'' do
    setup do
      invalid_data = {
        bad_context:  example_job(in_context: 'not hash'),
        bad_commands: example_job(with_commands: 'echo 1'),
        not_json:     'not_json'
      }
      invalid_data.each do |_type, datum|
        @client.request "#{@jobs_queue} #{datum}"
      end
    end

    should 'not run anything' do
      sleep $for_io_calls
      response = @client.request @jobs_queue
      assert_equal false, File.file?(@test_file)
    end
  end
end
