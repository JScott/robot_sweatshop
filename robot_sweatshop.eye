#!/usr/bin/env ruby
pid_path = File.expand_path configatron.common.pidfile_directory
log_path = File.expand_path configatron.common.logfile_directory

Eye.config do
  logger "#{log_path}/eye.log"
end

Eye.application :robot_sweatshop do
  trigger :flapping, times: 10, within: 1.minute, retry_in: 10.minutes
  check :cpu, every: 10.seconds, below: 100, times: 3
  working_dir '.'
  uid "#{configatron.common.user}" if configatron.common.has_key? :user
  gid "#{configatron.common.group}" if configatron.common.has_key? :group

  group 'input' do
    process :http do
      pid_file "#{pid_path}/input-http.pid"
      stdall "#{log_path}/input-http.log"
      start_command "sweatshop-input-http"
      daemonize true
    end
  end
  group 'queue' do
    process :handler do
      pid_file "#{pid_path}/queue-handler.pid"
      stdall "#{log_path}/queue-handler.log"
      start_command "sweatshop-queue-handler"
      daemonize true
    end
    process :broadcaster do
      pid_file "#{pid_path}/queue-broadcaster.pid"
      stdall "#{log_path}/queue-broadcaster.log"
      start_command "sweatshop-queue-broadcaster #{configatron.eye.broadcaster_interval}"
      daemonize true
    end
  end
  group 'job' do
    process :assembler do
      pid_file "#{pid_path}/job-assembler.pid"
      stdall "#{log_path}/job-assembler.log"
      start_command "sweatshop-job-assembler"
      daemonize true
    end
    process :worker do
      pid_file "#{pid_path}/job-worker.pid"
      stdall "#{log_path}/job-worker.log"
      start_command "sweatshop-job-worker #{configatron.eye.worker_id}"
      daemonize true
    end
  end
  process :payload_parser do
    pid_file "#{pid_path}/payload_parser.pid"
    stdall "#{log_path}/payload_parser.log"
    start_command "sweatshop-payload-parser"
    daemonize true
  end
end
