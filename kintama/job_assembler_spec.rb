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
    @parsed_payloads_queue = 'parsed-payload'
    @jobs_queue = 'jobs'
    clear_all_queues
  end

  given 'valid parsed payload data in \'parsed-payload\'' do
    setup do
      payload = example_parsed_payload(for_branch: 'develop')
      @client.request "#{@parsed_payloads_queue} #{payload}"
      sleep $for_a_while
    end

    should 'remove it from \'parsed-payload\'' do
      response = @client.request @parsed_payloads_queue
      assert_equal '', response
    end

    should 'enqueue commands, context, and job name to \'jobs\'' do
      response = @client.request "mirror-#{@jobs_queue}"
      response = JSON.parse response
      assert_kind_of Hash, response['context']
      assert_kind_of Array, response['commands']
      assert_kind_of String, response['job_name']
    end

    should 'convert objects into JSON strings' do
      response = @client.request "mirror-#{@jobs_queue}"
      response = JSON.parse response
      assert_kind_of Hash, response['context']['converts_to_string']
    end

    should 'only enqueue string objects to context' do
      response = @client.request "mirror-#{@jobs_queue}"
      response = JSON.parse response
      response['context'].each do |_key, value|
        assert_kind_of String, value
      end
    end
  end

  given 'invalid job data in \'parsed-payload\'' do
    setup do
      invalid_data = {
        ignored_branch: example_parsed_payload(for_branch: 'not_on_whitelist'),
        bad_payload:    example_parsed_payload(with_payload: 'not hash'),
        bad_job:        example_parsed_payload(for_job: 'asdf'),
        not_json:       'not_json'
      }
      invalid_data.each do |_type, datum|
        @client.request "#{@parsed_payloads_queue} #{datum}"
      end
      sleep $for_a_while
    end

    should 'remove all of it from \'parsed-payload\'' do
      response = @client.request @parsed_payloads_queue
      assert_equal '', response
    end

    should 'not queue anything to \'jobs\'' do
      response = @client.request @jobs_queue
      assert_equal '', response
    end
  end
end
