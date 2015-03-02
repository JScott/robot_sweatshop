#!/usr/bin/env ruby
require 'yaml'
require_relative '../queue-helper'

def get_config(for_job_name:)
  job_dir = "#{__dir__}/../../jobs"
  job_config_path = "#{job_dir}/#{for_job_name}.yaml"
  unless File.file? job_config_path
    puts "No config found for job '#{for_job_name}'"
    return nil
  end
  YAML.load_file job_config_path
end

def assemble_job(data)
  job_config = get_config for_job_name: data['job_name']
  return nil unless job_config
  if job_config['branch_whitelist'].include? data['payload']['branch']
    context = job_config['environment'].merge(data['payload'])
    context.each { |key, value| context[key] = value.to_s }
    {
      commands: job_config['commands'],
      context: context,
      job_name: data['job_name']
    }
  else
    puts "Branch '#{data['payload']['branch']}' is not whitelisted"
    nil
  end
end

QueueHelper.wait_for('parsed-payload') do |data|
  puts "Assembling: #{data}"
  assembled_job = assemble_job data
  QueueHelper.enqueue assembled_job, to: 'jobs' if assembled_job
end
