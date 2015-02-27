require 'kintama'
require_relative 'shared/moneta_backup'
require_relative 'shared/helpers'
require_relative '../lib/queue/lib/file-queue'

given 'the File Queue class' do
  include QueueHelper

  setup do
    clear_all_queues
  end

  should 'return a list of actively watched queues' do
    assert_kind_of Array, FileQueue.watched_queues
  end

  context 'an instance' do
    setup do
      @file_queue = FileQueue.new 'testing'
      @file_queue.clear
    end

    should 'return size' do
      assert_equal @file_queue.size, 0
    end

    should 'enqueue items' do
      @file_queue.enqueue 'item'
      assert_equal @file_queue.size, 1
    end

    should 'dequeue items' do
      @file_queue.enqueue 'item1'
      @file_queue.enqueue 'item2'
      assert_equal @file_queue.size, 2
      assert_equal @file_queue.dequeue, 'item1'
    end

    should 'clear items' do
      @file_queue.enqueue 'item'
      @file_queue.clear
      assert_equal @file_queue.size, 0
    end

    should 'return the queue on inspect' do
      assert_equal @file_queue.inspect, '[]'
    end
  end
end
