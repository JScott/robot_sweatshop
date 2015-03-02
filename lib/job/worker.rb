#!/usr/bin/env ruby
require 'faker'
require 'fileutils'
require_relative '../queue-helper'

# TODO: check existing worker ids. it'd be disastrous to have two sharing a workspace
@worker_id = ARGV[0] || "#{Faker::Name.first_name}"

def from_workspace(named: 'no_job_name')
  workspace = "#{named}-#{@worker_id}"
  puts "Workspace: #{workspace}"
  path = "#{__dir__}/workspaces/#{workspace}"
  FileUtils.mkpath path
  Dir.chdir(path) { yield if block_given? }
end

def execute(context = {}, command)
  puts "Executing '#{command}'..."
  # TODO: path.split(' ') to bypass the shell when we're not using env vars
  IO.popen(context, command) do |io|
    context.each { |key, value| ENV[key.to_s] = value.to_s }
    while line = io.gets
      puts line
    end
  end
  puts "Execution complete with exit status: #{$?.exitstatus}"
end

QueueHelper.wait_for('jobs') do |data|
  puts "Running: #{data}"
  if data['commands'].is_a? Array
    from_workspace(named: data['job_name']) do
      context = data['context'] || {}
      data['commands'].each { |command| execute context, command }
    end
  end
  puts "Job finished.\n\n"
end
