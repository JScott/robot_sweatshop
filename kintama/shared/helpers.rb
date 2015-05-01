require 'bundler/setup'
require 'yaml'
require 'json'
require 'sweatshop/moneta-queue'
require 'sweatshop/payload'
require 'sweatshop/config'

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
  def user_agent_for(format)
    case format
    when 'Bitbucket'
      'Bitbucket.org'
    when 'Github'
      'Github-Hookshot'
    else
      'SomeUserAgent'
    end
  end
  def example_payload_request(of_format:)
    {
      payload: example_raw_payload(of_format: of_format),
      user_agent: user_agent_for(of_format)
    }
  end
  def job_request_data(type)
    case type
    when 'Git'
      ['Bitbucket', 'git_job'] # develop branch payload
    when 'JSON'
      ['JSON', 'test_job']
    when 'Minimal'
      ['JSON', 'minimal_job']
    when 'IgnoredBranch'
      ['Github', 'git_job'] # master branch payload
    when 'UnknownJob'
      ['Bitbucket', 'unknown_job']
    when 'Empty'
      ['JSON', 'empty_job']
    else
      ['', '']
    end
  end
  def example_job_request(of_type:)
    format, job_name = job_request_data of_type
    JSON.generate payload: example_raw_payload(of_format: format),
                  job_name: job_name,
                  user_agent: user_agent_for(format)
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
