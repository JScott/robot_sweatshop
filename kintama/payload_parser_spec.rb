require 'kintama'
require 'ezmq'
require 'json'
require 'timeout'
require_relative 'shared/process_spawning'
require_relative 'shared/helpers'

describe 'the Payload Parser' do
  include QueueHelper
  include InHelper
  include PayloadHelper

  setup do
    @client = EZMQ::Client.new port: configatron.payload_parser_port
  end

  %w(Bitbucket Github JSON).each do |format|
    given "a valid #{format} payload" do
      setup do
        payload = example_raw_payload of_format: format
        @response = Timeout.timeout($for_a_while) do
          @client.request "#{payload}"
        end
      end

      should 'return a parsed payload' do
        @response = JSON.parse @response
        keys = case format
        when 'JSON'
          %w(test1 test2)
        else
          Payload.hash_keys
        end

        assert_kind_of Hash, @response
        keys.each do |key|
          assert_not_nil @response[key]
          assert_not_equal key, @response[key] # important for how Ruby interprets "string"['key']
        end
      end
    end
  end

  %w(Malformed NonJSON).each do |format|
    given "a #{format} payload" do
      setup do
        payload = example_raw_payload of_format: format
        @response = Timeout.timeout($for_a_while) do
          @client.request "#{payload}"
        end
      end

      should 'return an empty string' do
        assert_equal '', @response
      end
    end
  end
end
