#!/usr/bin/env ruby
require 'bundler/setup'
require 'yaml'
CONFIG = YAML.load_file '/tmp/.robot_sweatshop.eye-config.yaml'
PID_PATH = CONFIG[:pidfile_directory]
LOG_PATH = CONFIG[:logfile_directory]

Eye.config do
  logger "#{LOG_PATH}/eye.log"
end

Eye.application :robot_sweatshop do
  trigger :flapping, times: 10, within: 1.minute, retry_in: 10.minutes
  check :cpu, every: 10.seconds, below: 100, times: 3
  working_dir '.'
  uid "#{CONFIG[:user]}" if configatron.has_key? :user
  gid "#{CONFIG[:group]}" if configatron.has_key? :group

  group 'input' do
    process :http do
      pid_file "#{PID_PATH}/input-http.pid"
      stdall "#{LOG_PATH}/input-http.log"
      start_command "sweatshop-input-http"
      daemonize true
    end
  end
  group 'queue' do
    process :handler do
      pid_file "#{PID_PATH}/queue-handler.pid"
      stdall "#{LOG_PATH}/queue-handler.log"
      start_command "sweatshop-queue-handler"
      daemonize true
    end
    process :broadcaster do
      pid_file "#{PID_PATH}/queue-broadcaster.pid"
      stdall "#{LOG_PATH}/queue-broadcaster.log"
      start_command "sweatshop-queue-broadcaster #{CONFIG[:broadcaster_interval]}"
      daemonize true
    end
  end
  group 'job' do
    process :assembler do
      pid_file "#{PID_PATH}/job-assembler.pid"
      stdall "#{LOG_PATH}/job-assembler.log"
      start_command "sweatshop-job-assembler"
      daemonize true
    end
    process :worker do
      pid_file "#{PID_PATH}/job-worker.pid"
      stdall "#{LOG_PATH}/job-worker.log"
      start_command "sweatshop-job-worker #{CONFIG[:worker_id]}"
      daemonize true
    end
  end
  process :payload_parser do
    pid_file "#{PID_PATH}/payload_parser.pid"
    stdall "#{LOG_PATH}/payload_parser.log"
    start_command "sweatshop-payload-parser"
    daemonize true
  end
end
