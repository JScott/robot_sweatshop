require 'bundler/setup'
require 'yaml'
require 'oj'
require 'fileutils'
require 'robot_sweatshop/payload'
require 'robot_sweatshop/config'

$a_moment = 0.1
$a_while = 1

module InputHelper
  def example_raw_payload(format)
    payload_strings = YAML.load_file "#{__dir__}/../data/payload_data.yaml"
    payload_strings[format.downcase]
  end

  def input_url(for_job: 'test_job')
    "http://localhost:#{configatron.http_port}/payload-for/#{for_job}"
  end

  def job_enqueue(type)
    format, job = job_configuration type
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

  def job_configuration(type)
    format = 'JSON'
    format = 'Bitbucket' if type == 'Git' # develop branch
    format = 'Github' if type == 'IgnoredBranch' # master branch
    format = 'NonJSON' if type == 'NonJSON'

    job = 'test_job'
    job = 'git_job' if type == 'Git' || type == 'IgnoredBranch'
    job = 'minimal_job' if type == 'MinimalJob'
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

  def stub_output
    '.test.txt'
  end

  def stub_output_empty?
    (not File.exist? stub_output) || File.read(stub_output).empty?
  end

  def clear_stub_output
    FileUtils.touch '.test.txt'
    File.truncate '.test.txt', 0 # if File.exist? '.test.txt'
  end

  # def example_job(in_context: {}, with_commands: [])
  #   JSON.generate context: in_context,
  #                 commands: with_commands,
  #                 job_name: 'test_job'
  # end

  # def reset_test_file
  #   test_file = File.expand_path "#{configatron.workspace_path}/test_job-testingid/test.txt"
  #   FileUtils.rm_rf test_file
  #   test_file
  # end

  # def example_payload_request(of_format:)
  #   {
  #     payload: example_raw_payload(of_format: of_format),
  #     user_agent: user_agent_for(of_format)
  #   }
  # end
  # def example_job_request(of_type:)
  #   format, job_name = job_request_data of_type
  #   Oj.dump payload: example_raw_payload(of_format: format),
  #           job_name: job_name,
  #           user_agent: user_agent_for(format)
  # end
end
