#!/usr/bin/env ruby
require 'fileutils'
require_relative 'config'

log_path = configatron.common.logfile_directory
pid_path = configatron.common.pidfile_directory
FileUtils.mkdir_p log_path
FileUtils.mkdir_p pid_path

Eye.config do
  logger "#{log_path}/eye.log"
end

Eye.application 'robot_sweatshop' do
  trigger :flapping, times: 10, within: 1.minute, retry_in: 10.minutes
  check :cpu, every: 10.seconds, below: 100, times: 3
  working_dir "#{__dir__}/lib"

  group 'input' do
    process :http do
      pid_file "#{pid_path}/input-http.pid"
      stdall "#{log_path}/input-http.log"
      start_command "ruby input/http.rb"
      daemonize true
    end
  end
  group 'queue' do
    process :handler do
      pid_file "#{pid_path}/queue-handler.pid"
      stdall "#{log_path}/queue-handler.log"
      start_command "ruby queue/handler.rb"
      daemonize true
    end
    process :broadcaster do
      pid_file "#{pid_path}/queue-broadcaster.pid"
      stdall "#{log_path}/queue-broadcaster.log"
      start_command "ruby queue/broadcaster.rb"
      daemonize true
    end
  end
  group 'job' do
    process :assembler do
      pid_file "#{pid_path}/job-assembler.pid"
      stdall "#{log_path}/job-assembler.log"
      start_command "ruby job/assembler.rb"
      daemonize true
    end
    process :worker do
      pid_file "#{pid_path}/job-worker.pid"
      stdall "#{log_path}/job-worker.log"
      start_command "ruby job/worker.rb"
      daemonize true
    end
  end
  process :payload_parser do
    pid_file "#{pid_path}/payload_parser.pid"
    stdall "#{log_path}/payload_parser.log"
    start_command "ruby payload/parser.rb"
    daemonize true
  end
end
