require 'yaml'

CONFIG = YAML.load_file '/tmp/.robot_sweatshop-eye-config.yaml'
PID_PATH = CONFIG[:pidfile_directory]
LOG_PATH = CONFIG[:logfile_directory]

Eye.config do
  logger CONFIG[:log_file]
end

Eye.application :robot_sweatshop do
  trigger :flapping, times: 10, within: 1.minute, retry_in: 10.minutes
  check :cpu, every: 10.seconds, below: 100, times: 3
  working_dir CONFIG[:working_directory]
  uid "#{CONFIG[:user]}" if CONFIG[:user]
  gid "#{CONFIG[:group]}" if CONFIG[:group]

  group 'input' do
    process :http do
      pid_file "#{PID_PATH}/input-http.pid"
      stdall "#{LOG_PATH}/input-http.log"
      start_command "#{__dir__}/bin/sweatshop-input-http"
      daemonize true
    end
  end
  group 'queue' do
    process :handler do
      pid_file "#{PID_PATH}/queue-handler.pid"
      stdall "#{LOG_PATH}/queue-handler.log"
      start_command "#{__dir__}/bin/sweatshop-queue-handler"
      daemonize true
    end
    process :broadcaster do
      pid_file "#{PID_PATH}/queue-broadcaster.pid"
      stdall "#{LOG_PATH}/queue-broadcaster.log"
      start_command "#{__dir__}/bin/sweatshop-queue-broadcaster #{configatron.eye.broadcaster_interval}"
      daemonize true
    end
  end
  group 'job' do
    process :assembler do
      pid_file "#{PID_PATH}/job-assembler.pid"
      stdall "#{LOG_PATH}/job-assembler.log"
      start_command "#{__dir__}/bin/sweatshop-job-assembler"
      daemonize true
    end
    process :worker do
      pid_file "#{PID_PATH}/job-worker.pid"
      stdall "#{LOG_PATH}/job-worker.log"
      start_command "#{__dir__}/bin/sweatshop-job-worker #{configatron.eye.worker_id}"
      daemonize true
    end
  end
  process :payload_parser do
    pid_file "#{PID_PATH}/payload_parser.pid"
    stdall "#{LOG_PATH}/payload_parser.log"
    start_command "#{__dir__}/bin/sweatshop-payload-parser"
    daemonize true
  end
end
