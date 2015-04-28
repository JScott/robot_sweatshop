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
      'SomeRandomUserAgent'
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
      format = 'Bitbucket' # develop branch
      [example_raw_payload(of_format: format), 'git_job', user_agent_for(format)]
    when 'JSON'
      format = 'JSON'
      [example_raw_payload(of_format: format), 'test_job', user_agent_for(format)]
    when 'IgnoredBranch'
      format = 'Github' # master branch
      [example_raw_payload(of_format: format), 'git_job', user_agent_for(format)]
    when 'UnknownJob'
      format = 'Bitbucket'
      [example_raw_payload(of_format: format), 'unknown_job', user_agent_for(format)]
    when 'NonJSON'
      ['not json', 'git_job', user_agent_for('JSON')]
    else
      ['I', 'AM', 'ERROR']
    end
  end
  def example_job_request(of_type:)
    payload, job_name, user_agent = job_request_data of_type
    JSON.generate payload: payload,
                  job_name: job_name,
                  user_agent: user_agent
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
