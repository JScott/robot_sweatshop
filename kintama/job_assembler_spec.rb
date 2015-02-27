require 'kintama'
require 'ezmq'
require 'json'
require_relative 'shared/system'
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
      sleep $for_a_moment
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
  end

  given 'invalid job data in \'parsed-payload\'' do
    setup do
      bad_payload = JSON.generate payload: 'not hash', job_name: 'example'
      bad_job_name = JSON.generate payload: 'not hash', job_name: 'asdf'
      no_job_name = JSON.generate payload: 'not hash'
      not_json = 'not_json'
      ignored_branch = example_parsed_payload(for_branch: 'not_on_whitelist')
      [ bad_payload, bad_job_name, no_job_name, not_json, ignored_branch ].each do |bad_payload|
        @client.request "#{@parsed_payloads_queue} #{bad_payload}"
      end
      sleep $for_a_moment
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