#!/usr/bin/env ruby
require 'yaml'
require_relative '../queue-helper'

JOB_DIR = "#{__dir__}/../../jobs"

def assemble_job(parsed)
  job_config_path = "#{JOB_DIR}/#{parsed['job_name']}.yaml"
  return nil unless File.file? job_config_path
  job_config = YAML.load_file job_config_path

  issues = []
  if not job_config['branch_whitelist'].include? parsed['payload']['branch']
    issues.push "Branch '#{parsed['payload']['branch']}' not whitelisted"
  elsif parsed['payload'].class != Hash
    issues.push "Invalid payload"
  end

  if issues.empty?
    {
      commands: job_config['commands'],
      context: job_config['environment'].merge(parsed['payload'])
    }
  else
    puts "Dropping job:"
    issues.each { |issue| puts "  #{issue}" }
    nil
  end
end

QueueHelper.wait_for_queue('parsed-payload') do |data|
  puts "Assembling: #{data}"
  assembled_job = assemble_job data
  QueueHelper.enqueue assembled_job, to: 'jobs' if assembled_job
end