require 'kintama'
require 'ezmq'
require 'json'
require 'timeout'
require_relative 'shared/process_spawning'
require_relative 'shared/helpers'

describe 'the Payload Parser' do
  include QueueHelper
  include InHelper

  setup do
    @client = EZMQ::Client.new port: configatron.payload_parser_port
  end

  %w(Bitbucket Github JSON).each do |format|
    given "valid #{format} payloads" do
      setup do
        payload = example_raw_payload of_format: format
        @response = Timeout.timeout($for_a_while) do
          @client.request "#{payload}"
        end
      end

      should 'return a parsed payload object' do
        @response = JSON.parse @response
        assert_nil @response['error']
        assert_kind_of Hash, @response['payload']

        keys = case format
        when 'JSON'
          %w(test1 test2)
        else
          Payload.hash_keys
        end
        keys.each do |key|
          payload_value = @response['payload'][key]
          assert_not_nil payload_value
          assert_not_equal key, payload_value # catches "string"[key]
        end
      end
    end
  end

  %w(Empty NonJSON).each do |format|
    given "#{format} payloads" do
      setup do
        payload = example_raw_payload of_format: format
        @response = Timeout.timeout($for_a_while) do
          @client.request "#{payload}"
        end
      end

      should 'return an error object' do
        @response = JSON.load(@response)
        assert_kind_of String, @response['error']
        assert_nil @response['payload']
      end
    end
  end
end
