require 'kintama'
require 'ezmq'
require_relative 'shared/process_spawning'
require_relative 'shared/helpers'

given 'the Queue Handler' do
  include QueueHelper

  setup do
    @client = EZMQ::Client.new port: 5556
    @item = 'item'
    @queue = 'testing'
    clear_all_queues
  end
  
  context 'dequeuing' do
    setup { @request = "#{@queue}" }

    should 'return the next queued item' do
      enqueue @queue, @item
      response = @client.request @request
      assert_equal @item, response
    end

    should 'return \'\' for an empty queue' do
      response = @client.request @request
      assert_equal '', response
    end
  end

  context 'enqueuing' do
    setup { @request = "#{@queue} #{@item}" }

    should 'return the queue new size' do
      response = @client.request @request
      assert_equal '1', response
    end
  end

  context 'queue mirroring' do
    should 'mirror queue enqueuing' do
      enqueue @queue, @item
      response = @client.request "mirror-#{@queue}"
      assert_equal @item, response
    end

    should 'mirror queue clearing' do
      enqueue @queue, @item
      clear_all_queues
      response = @client.request "mirror-#{@queue}"
      assert_equal '', response
    end
  end
end
