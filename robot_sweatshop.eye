require 'yaml'

# TODO: per-user temp file
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

  group 'services' do
    process :job_dictionary do
      pid_file "#{PID_PATH}/job-dictionary.pid"
      stdall "#{LOG_PATH}/job-dictionary.log"
      start_command "#{__dir__}/bin/sweatshop-job-dictionary"
      daemonize true
    end
    process :payload_parser do
      pid_file "#{PID_PATH}/payload-parser.pid"
      stdall "#{LOG_PATH}/payload-parser.log"
      start_command "#{__dir__}/bin/sweatshop-payload-parser"
      daemonize true
    end
    process :conveyor do
      pid_file "#{PID_PATH}/conveyor.pid"
      stdall "#{LOG_PATH}/conveyor.log"
      start_command "#{__dir__}/bin/sweatshop-conveyor"
      daemonize true
    end
  end

  process :input do
    pid_file "#{PID_PATH}/input.pid"
    stdall "#{LOG_PATH}/input.log"
    start_command "#{__dir__}/bin/sweatshop-input"
    daemonize true
  end
  process :assembler do
    pid_file "#{PID_PATH}/assembler.pid"
    stdall "#{LOG_PATH}/assembler.log"
    start_command "#{__dir__}/bin/sweatshop-assembler"
    daemonize true
  end
  process :worker do
    pid_file "#{PID_PATH}/worker.pid"
    stdall "#{LOG_PATH}/worker.log"
    start_command "#{__dir__}/bin/sweatshop-worker"
    daemonize true
  end
end
