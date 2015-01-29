require 'kintama'
require 'ezmq'
require 'timeout'
require_relative 'helpers'

given 'the Queue Broadcaster' do
  include QueueHelper

  setup do
    @subscriber = EZMQ::Subscriber.new port: 5557, topic: 'busy-queues'
    @item = 'item'
    @queue = 'testing'
    clear_queue @queue
  end
  
  context 'a non-empty queue' do
    setup do
      enqueue @queue, @item
    end

    should 'have their named published to \'busy-queues\'' do
      Timeout.timeout(1) do
        @subscriber.listen do |message|
          topic, message = message.split ' '
          assert_equal @queue, message
          break
        end
      end
    end
  end

  context 'an empty queue' do
    should 'not have their name published' do
      raise "Have not figured out fail capturing in Kintama yet..."
      #Timeout.timeout(1) do
      #  @subscriber.listen { |m| }
      #end
    end
  end
  
  teardown do
  end
end