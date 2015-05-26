require 'bundler/setup'
require 'yaml'
require 'oj'
require 'robot_sweatshop/payload'
require 'robot_sweatshop/config'

module InputHelper
  def example_raw_payload(format)
    payload_strings = YAML.load_file "#{__dir__}/../../data/payload_data.yaml"
    payload_strings[format.downcase]
  end

  def input_url(for_job: 'test_job')
    "http://localhost:#{configatron.http_port}/run/#{for_job}"
  end

  def conveyor_enqueue(type)
    format, job = payload_configuration type
    {
      method: 'enqueue',
      data: {
        payload: example_raw_payload(format),
        user_agent: user_agent_for(format),
        job_name: job
      }
    }
  end

  def payload_parser_request(format)
    {
      payload: example_raw_payload(format),
      user_agent: user_agent_for(format)
    }
  end

  def worker_push
    {
      commands: [
        'echo $custom',
        'echo $custom > test.txt'
      ],
      context: {'custom' => 'hello world'},
      job_name: 'test_job',
      job_id: 1
    }
  end

  def payload_configuration(type)
    format = 'JSON'
    format = 'Bitbucket' if type == 'Git' # develop branch
    format = 'Github' if type == 'IgnoredBranch' # master branch
    format = 'NonJSON' if type == 'NonJSON'
    format = 'EmptyJSON' if type == 'EmptyJSON'

    job = 'test_job'
    job = 'git_job' if type == 'Git' || type == 'IgnoredBranch'
    job = 'minimal_job' if type == 'MinimalJob' || type == 'EmptyJSON'
    job = 'unknown_job' if type == 'UnknownJob' # TODO: why does commenting this out still pass payload parser?!
    job = 'empty_job' if type == 'EmptyJob'

    [format, job]
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
end
