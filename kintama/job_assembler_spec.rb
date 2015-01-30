require 'kintama'
require 'ezmq'
require 'json'
require_relative 'helpers'

given 'the Job Assembler' do
  include QueueHelper

  setup do
    FileQueue.mirroring = true
    @client = EZMQ::Client.new port: 5556
    @raw_queue = 'raw-payload'
    @parsed_queue = 'parsed-payload'
    clear_queue @raw_queue
    clear_queue @parsed_queue
    clear_queue @queue
  end
  
  context 'queuing valid payload data to raw-payload' do
    setup do
      @valid_payloads = [
        { payload: load_payload('Bitbucket'), format: 'Bitbucket' }
        # TODO: refactor and add github
      ]
      @valid_payloads.map! { |payload| JSON.generate payload }
    end

    should 'remove it from raw-payload' do
      response = @client.request @raw_queue
      assert_equal '', response
    end

    should 'enqueue parsed payload data to parsed-payload' do
      @valid_payloads.each do |payload|
        @client.request "#{@raw_queue} #{payload}"
        sleep 1
        response = @client.request @parsed_queue
        response = JSON.parse response
        %w(author hash branch message repo_slug source_url clone_url).each do |key|
          assert_not_nil response[key]
          assert_not_equal key, response[key] # important for how Ruby interprets "string"['key']
        end
      end
    end
  end

  context 'queuing invalid payload data to raw-payload' do
    setup do
      bad_payload = { payload: load_payload('malformed'), format: 'asdf' }
      @client.request "#{@raw_queue} #{bad_payload}"
      @client.request "#{@raw_queue} not json"
      sleep 1
      # TODO: should not crash the payload parser
    end

    should 'remove it from raw-payload' do
      response = @client.request @raw_queue
      assert_equal '', response
    end

    should 'not queue anything to parsed-payload' do
      response = @client.request @parsed_queue
      assert_equal '', response
    end
  end

  teardown do
  end
end