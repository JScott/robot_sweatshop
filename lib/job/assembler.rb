#!/usr/bin/env ruby
require 'yaml'
require_relative '../queue-helper'

def get_config(for_job_name:)
  job_dir = "#{__dir__}/../../jobs"
  job_config_path = "#{job_dir}/#{for_job_name}.yaml"
  return nil unless File.file? job_config_path
  job_config = YAML.load_file job_config_path
end 

def issues_with(job_config = {}, for_payload: {})
  issues = []
  if for_payload.class != Hash
    issues.push "Invalid payload"
  elsif not job_config['branch_whitelist'].include? for_payload['branch']
    issues.push "Branch '#{for_payload['branch']}' not whitelisted"
  end
  issues
end

def assemble_job(parsed)
  job_config = get_config for_job_name: parsed['job_name']
  issues = issues_with job_config, for_payload: parsed['payload']
  if issues.empty?
    {
      commands: job_config['commands'],
      context: job_config['environment'].merge(parsed['payload']),
      job_name: parsed['job_name']
    }
  else
    puts "Dropping job:"
    issues.each { |issue| puts "  #{issue}" }
    nil
  end
end

QueueHelper.wait_for('parsed-payload') do |data|
  puts "Assembling: #{data}"
  assembled_job = assemble_job data
  QueueHelper.enqueue assembled_job, to: 'jobs' if assembled_job
end