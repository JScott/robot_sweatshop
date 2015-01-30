require 'yaml'
require_relative '../lib/queue/lib/file-queue'
require_relative '../lib/payload/lib/payload'

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

module PayloadHelper
  def load_payload(of_format)
    payload_strings = YAML.load_file "#{__dir__}/data/payloads.yaml"
    payload_strings[of_format]
  end

  def example_payload(with_format:)
    payload = load_payload with_format
    JSON.generate payload: payload, format: with_format
  end
end

module JobHelper
  def example_job
    YAML.load_file "#{__dir__}/data/job.yaml"
  end
end