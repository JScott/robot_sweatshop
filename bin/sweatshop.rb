#!/usr/bin/env ruby
require 'yaml'
require 'commander/import'
require 'colorize'

# :name is optional, otherwise uses the basename of this executable
program :name, 'Robot Sweatshop'
program :version, '0.1.0'
program :description, 'A lightweight, unopinionated CI server'
program :help, 'Author', 'Justin Scott <jvscott@gmail.com>'

# default_command :bootstrap

def empty_job
  "---\nbranch_whitelist:\n- master\n\ncommands:\n- echo 'Hello $WORLD!'\n\nenvironment:\n  WORLD: Earth\n"
end

def notify(type = :success, string)
  color = case type
  when :success
    :green
  when :failure
    :red
  when :warning
    :yellow
  when :info
    :light_blue
  else
    ''
  end
  puts "[#{type.to_s.capitalize.colorize(color)}] #{string}"
end

def create_and_edit(job_file:)
  name = File.basename job_file
  unless File.file?(job_file)
    File.write job_file, empty_job
    notify :success, "Created new job file '#{name}'"
  end
  notify :info, "Manually editing job file '#{name}'"
  system ENV['EDITOR'], job_file
end

def valid_lists?(job)
  errors = false
  %w(branch_whitelist commands).each do |list|
    if job[list].nil? || job[list].empty?
      notify :failure, "#{list} empty or not found"
      errors = true
    end
  end
  errors
end

def valid_environment?(job)
  errors = false
  job['environment'].each do |key, value|
    unless value.is_a? String
      notify :warning, "Non-string value for '#{key}'"
      errors = true
    end
  end
  errors
end

def valid_yaml?(job)
  if job
    true
  else
    notify :failure, "Invalid YAML"
    false
  end
end

def validate(job_file:)
  name = File.basename job_file
  unless File.file?(job_file)
    notify :failure, 'Job not found. Create it with \'workshop job\''
  else
    job = YAML.load_file job_file
    return unless valid_yaml?(job)
    errors = valid_lists?(job) ||
             valid_environment?(job)
    notify :success, 'Valid job configuration' unless errors
  end
end

def with_job_file(for_job:)
  if for_job.nil?
    notify :failure, 'Please specify the job to create or edit. See --help for details'
  else
    yield "#{__dir__}/../jobs/#{for_job}.yaml"
  end
end

command :job do |c|
  c.syntax = 'sweatshop job <name>'
  c.description = 'Creates and edits jobs'
  c.action do |args|
    with_job_file for_job: args.first do |file|
      create_and_edit job_file: file
    end
  end
end

command :inspect do |c|
  c.syntax = 'sweatshop.rb inspect <name>'
  c.description = 'Verify the structure of a job'
  c.action do |args|
    with_job_file for_job: args.first do |file|
      validate job_file: file
    end
  end
end


# command :bar do |c|
#   c.syntax = 'foobar bar [options]'
#   c.description = 'Display bar with optional prefix and suffix'
#   c.option '--prefix STRING', String, 'Adds a prefix to bar'
#   c.option '--suffix STRING', String, 'Adds a suffix to bar'
#   c.action do |args, options|
#     options.default :prefix => '(', :suffix => ')'
#     say "#{options.prefix}bar#{options.suffix}"
#   end
# end
