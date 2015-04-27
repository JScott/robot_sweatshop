require 'yaml'
require 'json'
require_relative '../../lib/sweatshop/moneta-queue'
require_relative '../../lib/sweatshop/payload/payload'
require_relative '../../lib/sweatshop/config'

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
  def example_raw_payload(of_format:)
    payload_strings = YAML.load_file "#{__dir__}/../data/payload_data.yaml"
    payload_strings[of_format.downcase]
  end
  def input_http_url(for_job: 'test_job')
    "http://localhost:#{configatron.http_port}/payload-for/#{for_job}"
  end
end

module PayloadHelper
  def example_job_request(of_type:)
    payload, job_name = case of_type
    when 'Valid'
      payload = example_raw_payload of_format: 'JSON'
      [payload, 'test_job']
    when 'IgnoredBranch'
      payload = example_raw_payload of_format: 'Github' # master branch
      [payload, 'test_job']
    when 'UnknownJob'
      payload = example_raw_payload of_format: 'Bitbucket' # develop branch
      [payload, 'unknown_job']
    when 'NonJSON'
      ['not json', 'test_job']
    else
      ['', '']
    end
    JSON.generate payload: payload,
                  job_name: job_name
  end
end

module JobHelper
  def example_job(in_context: {}, with_commands: [])
    JSON.generate context: in_context,
                  commands: with_commands,
                  job_name: 'test_job'
  end
  def reset_test_file
    test_file = File.expand_path "#{configatron.workspace_directory}/test_job-testingid/test.txt"
    FileUtils.rm_rf test_file
    test_file
  end
end
