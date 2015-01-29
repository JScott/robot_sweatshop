require 'kintama'
require 'ezmq'
require_relative 'helpers'

context 'Queue Handler' do
  include QueueHelper

  setup do
    FileQueue.mirroring = true
    @client = EZMQ::Client.new port: 5556
    @item = 'item'
    @queue = 'testing'
    clear_queue @queue
  end
  
  should "dequeue items and return the item" do
    enqueue @queue, @item
    response = @client.request @queue
    assert_equal response, @item
  end
  should "return an empty string when dequeuing an empty queue" do
    response = @client.request @queue
    assert_equal response, ''
  end
  should "enqueue items and returns the queue size" do
    response = @client.request "#{@queue} #{@item}"
    assert_equal response, '1'
  end
  should "support queue mirroring" do
    assert_equal FileQueue.mirroring, true
    enqueue @queue, @item
    response = @client.request "mirror-#{@queue}"
    assert_equal response, @item
  end

  teardown do
  end
end