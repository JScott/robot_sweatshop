require 'kintama'
require 'ezmq'
require 'json'
require_relative 'helpers'

describe 'the Job Assembler' do
  include QueueHelper
  include PayloadHelper
  include JobHelper

  setup do
    FileQueue.mirroring = true
    @client = EZMQ::Client.new port: 5556
    @parsed_payloads_queue = 'parsed-payload'
    @jobs_queue = 'jobs'
    clear_queue @parsed_payloads_queue
    clear_queue @jobs_queue
    @job_config = example_job_config
  end

  given "valid parsed payload data in 'parsed-payload'" do
    setup do
      payload = example_parsed_payload(for_branch: 'develop')
      @client.request "#{@raw_queue} #{payload}"
      sleep 1
    end

    should 'remove it from \'raw-payload\'' do
      response = @client.request @raw_queue
      assert_equal '', response
    end

    should 'enqueue parsed payload data and job name to \'parsed-payload\'' do
      response = @client.request @parsed_queue
      response = JSON.parse response

      Payload.hash_keys.each do |key|
        assert_not_nil response['payload'][key]
        assert_not_equal key, response['payload'][key] # important for how Ruby interprets "string"['key']
      end
      assert_not_nil response['job_name']
    end
  end

  given 'finds invalid job data in \'parsed-payload\'' do
    setup do
      bad_payload = JSON.generate payload: 'not hash', job_name: 'asdf'
      not_json = 'not_json'
      [ bad_payload, not_json ].each do |bad_payload|
        @client.request "#{@raw_queue} #{bad_payload}"
      end
      sleep 1
    end

    should 'remove it from \'parsed-payload\'' do
      response = @client.request @parsed_payloads_queue
      assert_equal '', response
    end

    should 'not queue anything to \'jobs\'' do
      response = @client.request @jobs_queue
      assert_equal '', response
    end
  end
end