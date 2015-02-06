require 'yaml'
require_relative '../lib/queue/lib/file-queue'
require_relative '../lib/payload/lib/payload'

$for_a_moment = 0.1

@threads = []
def spawn(path)
  @threads << Thread.new { `#{path}` }
end

Kintama.on_start do
  @threads = []
  spawn "#{__dir__}/../lib/queue/broadcaster.rb"
  spawn "#{__dir__}/../lib/queue/handler.rb"
  spawn "#{__dir__}/../lib/payload/parser.rb"
  sleep $for_a_moment
end

Kintama.on_finish do
  @threads.each do |thread|
    Thread.kill thread
  end
end

module QueueHelper
  def clear_all_queues
    FileQueue.clear_all
  end
  def enqueue(queue_name, item)
    queue = FileQueue.new queue_name
    queue.enqueue item
  end
end

module InHelper
  def load_payload(of_format)
    payload_strings = YAML.load_file "#{__dir__}/data/payload_data.yaml"
    payload_strings[of_format]
  end

  def example_raw_payload(with_format:)
    payload = load_payload with_format
    JSON.generate payload: payload, format: with_format, job_name: 'example'
  end
end

module PayloadHelper
  def example_parsed_payload(for_branch:)
    JSON.generate payload: { branch: for_branch }, job_name: 'example'
  end
end

module JobHelper
  def example_job_config
    YAML.load_file "#{__dir__}/data/job.yaml"
  end
end