require 'kintama'
require 'ezmq'
require 'json'
require_relative 'shared/moneta_backup'
require_relative 'shared/process_spawning'
require_relative 'shared/helpers'

describe 'the Worker' do
  include QueueHelper
  include JobHelper

  setup do
    @client = EZMQ::Client.new port: 5556
    @jobs_queue = 'jobs'
    @test_file = reset_test_file
    clear_all_queues
  end

  given 'valid job data in \'jobs\'' do
    setup do
      job = example_job
      @client.request "#{@jobs_queue} #{job}"
      sleep $for_a_moment
    end

    should 'remove it from \'jobs\'' do
      response = @client.request @jobs_queue
      assert_equal '', response
    end

    should 'run the dequeued job' do
      assert_equal File.file?(@test_file), true
    end

    should 'run jobs with the context as environment variables' do
      assert_equal File.read(@test_file), 'Hello world!'
    end
  end

  given 'invalid job data in \'jobs\'' do
    setup do
      invalid_data = {
        bad_context:  JSON.generate(context: 'not hash', commands: []),
        bad_commands: JSON.generate(context: [], commands: 'echo 1'),
        not_json:     'not_json'
      }
      invalid_data.each do |_type, datum|
        @client.request "#{@jobs_queue} #{datum}"
      end
      sleep $for_a_moment
    end

    should 'remove all of it from \'jobs\'' do
      response = @client.request @jobs_queue
      assert_equal '', response
    end

    should 'not run anything' do
      response = @client.request @jobs_queue
      assert_equal File.file?(@test_file), false
    end
  end
end
