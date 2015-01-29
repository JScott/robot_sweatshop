require 'kintama'
require 'ezmq'
require_relative 'helpers'

describe 'the Payload Parser' do
  include QueueHelper
  include PayloadHelper

  setup do
    FileQueue.mirroring = true
    @client = EZMQ::Client.new port: 5556
    @raw_queue = 'raw-payload'
    @parsed_queue = 'parsed-payload'
    clear_queue @raw_queue
    clear_queue @parsed_queue
    clear_queue @queue
  end
  
  context 'valid data' do
    setup do
      @valid_payloads = [
        load_payload('Bitbucket')
      ]
    end

    should 'get moved from raw to parsed queues' do
      @valid_payloads.each do |payload|
        enqueue @queue, payload
        sleep 1
        response = @client.request @raw_queue
        assert_equal '', response
        response = @client.request @parsed_queue
        assert_not_equal '', response
      end
    end
  end

  teardown do
  end
end