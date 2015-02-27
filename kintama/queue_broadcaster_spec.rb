require 'kintama'
require 'ezmq'
require 'timeout'
require_relative 'shared/moneta_backup'
require_relative 'shared/process_spawning'
require_relative 'shared/helpers'

given 'the Queue Broadcaster' do
  include QueueHelper

  setup do
    @subscriber = EZMQ::Subscriber.new port: 5557, topic: 'busy-queues'
    @item = 'item'
    @queue = 'testing'
    clear_all_queues
  end
  
  context 'a non-empty queue' do
    setup { enqueue @queue, @item }

    should 'have their named published to \'busy-queues\'' do
      Timeout.timeout($for_a_while) do
        @subscriber.listen do |message|
          assert_equal @queue, message
          break
        end
      end
    end
  end

  context 'an empty queue' do
    should 'not have their name published' do
      assert_raises Timeout::Error do
        Timeout.timeout($for_a_moment) do
          @subscriber.listen { }
        end
      end
    end
  end
end
