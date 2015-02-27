#!/usr/bin/env ruby
require 'faker'
require 'fileutils'
require_relative '../queue-helper'

@worker_id = ARGV[0] || "#{Faker::Name.first_name}"

def from_workspace(named:)
  path = "#{__dir__}/workspaces/#{named}-#{@worker_id}"
  FileUtils.mkpath path
  Dir.chdir(path) { yield if block_given? }
end

def execute(command)
  puts "Executing '#{command}'..."
  # TODO: path.split(' ') to bypass the shell when we're not using env vars
  IO.popen(command) do |io|
    while line = io.gets # do
      log.info line
    end
  end
  puts "Execution complete with exit status: #{$CHILD_STATUS.exitstatus}"
end

QueueHelper.wait_for('jobs') do |data|
  puts "Running: #{data}"
  puts "Worker ID: #{@worker_id}"
  if data['context'].is_a? Hash
    data['context'].each { |key, value| ENV[key.to_s] = value.to_s }
  end
  if data['commands'].is_a? Array
    from_workspace(named: data['job_name']) do
      data['commands'].each { |command| execute command }
    end
  end
end
