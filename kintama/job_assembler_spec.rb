require 'kintama'
require 'ezmq'
require 'json'
require_relative 'shared/process_spawning'
require_relative 'shared/helpers'

describe 'the Job Assembler' do
  include QueueHelper
  include PayloadHelper
  include JobHelper

  setup do
    @client = EZMQ::Client.new port: 5556
    @payloads_queue = 'payload'
    @jobs_queue = 'jobs'
    clear_all_queues
  end

  given 'valid requests in \'payload\'' do
    setup do
      payload = example_job_request of_type: 'Valid'
      @response = Timeout.timeout($for_a_while) do
        @client.request "#{@payloads_queue} #{payload}"
      end
    end

    should 'remove the request from \'payload\'' do
      response = @client.request @payloads_queue
      assert_equal '', response
    end

    should 'enqueue commands, context, and job name to \'jobs\'' do
      response = @client.request "mirror-#{@jobs_queue}"
      response = JSON.load response
      assert_kind_of Hash, response['context']
      assert_kind_of Array, response['commands']
      assert_kind_of String, response['job_name']
    end

    should 'only enqueue strings into context' do
      response = @client.request "mirror-#{@jobs_queue}"
      response = JSON.load response
      response['context'].each do |_key, value|
        assert_kind_of String, value
      end
    end

    should 'build the context with a parsed payload' do
      response = @client.request "mirror-#{@jobs_queue}"
      response = JSON.load response
      assert_kind_of Hash, response['context']
      assert_equal 'value', response['context']['test1']
    end
  end

  %w(IgnoredBranch UnknownJob NonJSON).each do |request|
    given "#{format} requests in \'payload\'" do
      setup do
        payload = example_job_request of_type: request
        @response = Timeout.timeout($for_a_while) do
          @client.request "#{@payloads_queue} #{payload}"
        end
      end

      should 'remove the request from \'payload\'' do
        response = @client.request @payloads_queue
        assert_equal '', response
      end

      should 'not queue anything to \'jobs\'' do
        response = @client.request @jobs_queue
        assert_equal '', response
      end
    end
  end
end
