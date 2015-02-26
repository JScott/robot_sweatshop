#!/usr/bin/env ruby
require 'yaml'
require_relative '../queue-helper'

def get_config(for_job_name:)
  job_dir = "#{__dir__}/../../jobs"
  job_config_path = "#{job_dir}/#{for_job_name}.yaml"
  return nil unless File.file? job_config_path
  YAML.load_file job_config_path
end

def issues_with(job_config = {}, data = {})
  payload = data['payload']
  issues = []
  missing_job_name = data['job_name'].nil?
  missing_config = job_config.nil?
  invalid_payload = payload.class != Hash
  unless missing_config || invalid_payload
    ignored_branch = !job_config['branch_whitelist'].include?(payload['branch'])
  end
  issues.push "Could not find the job configuration" if missing_config
  issues.push "Invalid payload" if invalid_payload
  issues.push "Branch '#{payload['branch']}' is not whitelisted" if ignored_branch
  issues.push "The job name is missing" if missing_job_name
  issues
end

def assemble_job(data)
  job_config = get_config for_job_name: data['job_name']
  issues = issues_with job_config, data
  if issues.empty?
    {
      commands: job_config['commands'],
      context: job_config['environment'].merge(data['payload']),
      job_name: data['job_name']
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