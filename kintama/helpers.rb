require 'yaml'
require_relative '../lib/queue/lib/file-queue'
require_relative '../lib/payload/lib/payload'

$for_a_moment = 0.1

def spawn(lib_path)
  puts "Starting #{lib_path}..."
  null_io = File.open File::NULL, 'w'
  @pids << Process.spawn("#{__dir__}/../lib/#{lib_path}", out: null_io, err: null_io)
  sleep 0.5
end

Kintama.on_start do
  @pids = []
  spawn 'queue/handler.rb'
  spawn 'queue/broadcaster.rb'
  spawn 'payload/parser.rb'
end

Kintama.on_finish do
  @pids.each do |pid|
    Process.kill :TERM, pid
    Process.wait pid
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