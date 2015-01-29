require_relative '../lib/queue/lib/file-queue'

module QueueHelper
  def clear_queue(queue_name)
    queue = FileQueue.new queue_name
    queue.clear
    assert_equal queue.size, 0
  end
  def enqueue(queue_name, item)
    queue = FileQueue.new queue_name
    queue.enqueue item
  end
end
