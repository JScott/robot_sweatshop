require 'yaml'

CONFIG = YAML.load_file '/tmp/.robot_sweatshop-eye-config.yaml'
PID_PATH = CONFIG[:pidfile_path]
LOG_PATH = CONFIG[:logfile_path]

Eye.config do
  logger "#{CONFIG[:logfile_path]}/eye.log"
end

Eye.application :robot_sweatshop do
  trigger :flapping, times: 10, within: 1.minute, retry_in: 10.minutes
  check :cpu, every: 10.seconds, below: 100, times: 3
  working_dir CONFIG[:working_path]

  process :input do
    pid_file "#{PID_PATH}/input.pid"
    stdall "#{LOG_PATH}/input.log"
    start_command "#{__dir__}/bin/sweatshop-input"
    daemonize true
  end
  process :conveyor do
    pid_file "#{PID_PATH}/conveyor.pid"
    stdall "#{LOG_PATH}/conveyor.log"
    start_command "#{__dir__}/bin/sweatshop-conveyor"
    daemonize true
  end
  # group 'job' do
  #   process :assembler do
  #     pid_file "#{PID_PATH}/job-assembler.pid"
  #     stdall "#{LOG_PATH}/job-assembler.log"
  #     start_command "#{__dir__}/bin/sweatshop-job-assembler"
  #     daemonize true
  #   end
  #   process :worker do
  #     pid_file "#{PID_PATH}/job-worker.pid"
  #     stdall "#{LOG_PATH}/job-worker.log"
  #     start_command "#{__dir__}/bin/sweatshop-job-worker #{configatron.eye.worker_id}"
  #     daemonize true
  #   end
  # end
  # process :payload_parser do
  #   pid_file "#{PID_PATH}/payload_parser.pid"
  #   stdall "#{LOG_PATH}/payload_parser.log"
  #   start_command "#{__dir__}/bin/sweatshop-payload-parser"
  #   daemonize true
  # end
end
