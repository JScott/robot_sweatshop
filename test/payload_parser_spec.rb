require 'bundler/setup'
require 'kintama'
require 'ezmq'
require 'oj'
require 'timeout'
require 'robot_sweatshop/config'
require_relative 'shared/setup'
require_relative 'shared/helpers'
$stdout.sync = true

Kintama.on_start do
  @pid = Setup::process 'payload-parser'
end

Kintama.on_finish do
  Process.kill 'TERM', @pid
end

describe 'the Payload Parser' do
  include InputHelper

  setup do
    @client = Setup::client port: configatron.payload_parser_port
  end

  %w(Bitbucket Github JSON Empty).each do |format|
    given "valid #{format} payloads" do
      setup do
        payload = payload_parser_request(format)
        @response = Timeout.timeout($a_while) do
          @client.request(payload, {})
        end
      end

      should 'return a parsed payload object' do
        assert_equal true, @response[:error].empty?
        assert_kind_of Hash, @response[:payload]

        keys = Payload.hash_keys
        keys = %w(test1 test2) if format == 'JSON'
        keys = [] if format == 'Empty'
        keys.each do |key|
          payload = @response[:payload]
          assert_not_nil payload[key]
          assert_not_equal key, payload[key] # catches "string"[key]
        end
      end
    end
  end

  %w(NonJSON).each do |format|
    given "#{format} payloads" do
      setup do
        payload = payload_parser_request(format)
        @response = Timeout.timeout($a_while) do
          @client.request(payload, {})
        end
      end

      should 'return an error object' do
        assert_kind_of String, @response[:error]
        assert_equal true, @response[:payload].empty?
      end
    end
  end
end
