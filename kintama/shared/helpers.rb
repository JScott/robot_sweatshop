require 'yaml'
require 'json'
require_relative '../../lib/queue/lib/moneta-queue'
require_relative '../../lib/payload/lib/payload'
require_relative '../../config'

module QueueHelper
  def clear_all_queues
    MonetaQueue.watched_queues.each do |queue|
      queue = MonetaQueue.new queue
      queue.clear
    end
  end
  def enqueue(queue_name, item)
    queue = MonetaQueue.new queue_name
    queue.enqueue item
  end
end

module InHelper
  def load_payload(of_format)
    payload_strings = YAML.load_file "#{__dir__}/../data/payload_data.yaml"
    payload_strings[of_format.downcase]
  end
  def example_raw_payload(with_format:)
    payload = load_payload with_format
    JSON.generate payload: payload,
                  format: with_format,
                  job_name: 'example'
  end
  def input_http_url(for_job: 'example', in_format: 'bitbucket')
    "http://localhost:#{configatron.input.http.port}/#{in_format}/payload-for/#{for_job}"
  end
end

module PayloadHelper
  def example_parsed_payload(with_payload: nil, for_branch: 'develop', for_job: 'example')
    payload = with_payload || { branch: for_branch }
    JSON.generate payload: payload,
                  job_name: for_job
  end
end

module JobHelper
  def example_job(in_context: {}, with_commands: [])
    JSON.generate context: in_context,
                  commands: with_commands,
                  job_name: 'example'
  end
  def reset_test_file
    test_file = File.expand_path "#{configatron.worker.workspace_directory}/example-testingid/test.txt"
    FileUtils.rm_rf test_file
    test_file
  end
end
