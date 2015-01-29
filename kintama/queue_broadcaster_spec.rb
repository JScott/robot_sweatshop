require 'kintama'
require 'ezmq'
require 'timeout'
require_relative 'helpers'

context 'Queue Broadcaster' do
  include QueueHelper

  setup do
    @subscriber = EZMQ::Subscriber.new port: 5557, topic: 'busy-queues'
    @item = 'item'
    @queue = 'testing'
    clear_queue @queue
  end
  
  should "publishes the name of non-empty queues to 'busy-queues'" do
    enqueue @queue, @item
    Timeout.timeout(1) do
      @subscriber.listen do |message|
        topic, message = message.split ' '
        assert_equal message, @queue
        break
      end
    end
  end
  should "does not publish the name of empty queues" do
    raise 'There is no "expect error" in Kintama so I can\'t implement this yet'
    #Timeout.timeout(1) do
    #  @subscriber.listen { |m| }
    #end
  end

  teardown do
  end
end