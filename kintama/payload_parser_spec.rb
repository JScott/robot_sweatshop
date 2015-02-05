require 'kintama'
require 'ezmq'
require 'json'
require_relative 'helpers'

describe 'the Payload Parser' do
  include QueueHelper
  include InHelper
  include PayloadHelper

  setup do
    FileQueue.mirroring = true
    @client = EZMQ::Client.new port: 5556
    @raw_queue = 'raw-payload'
    @parsed_queue = 'parsed-payload'
    clear_queue @raw_queue
    clear_queue @parsed_queue
  end

  # TODO: refactor and add github
  ['Bitbucket'].each do |format|
    given "valid #{format} data in 'raw-payload'" do
      setup do
        payload = example_raw_payload(with_format: format)
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
  end

  given 'invalid payload data in \'raw-payload\'' do
    setup do
      malformed_payload = JSON.generate payload: load_payload('malformed'), format: 'asdf'
      not_json = 'not_json'
      unsupported_format = example_raw_payload with_format: 'asdf'
      [ malformed_payload, not_json, unsupported_format ].each do |bad_payload|
        @client.request "#{@raw_queue} #{bad_payload}"
      end
      sleep 1
      # TODO: should not crash the payload parser
    end

    should 'remove it from \'raw-payload\'' do
      response = @client.request @raw_queue
      assert_equal '', response
    end

    should 'not queue anything to \'parsed-payload\'' do
      response = @client.request @parsed_queue
      assert_equal '', response
    end
  end
end