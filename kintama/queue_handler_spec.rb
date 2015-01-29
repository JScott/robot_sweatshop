require 'kintama'
require 'ezmq'
require_relative 'helpers'

context 'Queue Handler' do
  include QueueHelper

  setup do
    clear_queue 'testing'
    FileQueue.mirroring = true
    @client = EZMQ::Client.new port: 5556
  end
  
  should "dequeue items and return the item" do
    item = 'item'
    enqueue item
    response = @client.request 'testing'
    assert_equal response, item
  end
  should "return an empty string when dequeuing an empty queue" do
    response = @client.request 'testing'
    assert_equal response, ''
  end
  should "enqueue items and returns the queue size" do
    response = @client.request 'testing item'
    assert_equal response, '1'
  end
  should "support queue mirroring" do
    assert_equal FileQueue.mirroring, true
    item = 'item'
    enqueue item
    response = @client.request 'mirror-testing'
    assert_equal response, item
  end

  teardown do
  end
end