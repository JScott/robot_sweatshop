require 'fileutils'

log_path = '/var/log/robot_sweatshop'
pid_path = '/var/run/robot_sweatshop'
FileUtils.mkdir_p log_path
FileUtils.mkdir_p pid_path

Eye.config do
  logger "#{log_path}/eye.log"
end

Eye.application 'robot_sweatshop' do
  trigger :flapping, times: 10, within: 1.minute, retry_in: 10.minutes
  check :cpu, every: 10.seconds, below: 100, times: 3
  working_dir "#{__dir__}/lib"

  group 'services' do
    process :input_http do
      pid_file "#{pid_path}/input-http.pid"
      stdall "#{log_path}/input-http.log"
      start_command "sudo ruby input/http.rb"
      daemonize true
    end
    process :queue_handler do
      pid_file "#{pid_path}/queue-handler.pid"
      stdall "#{log_path}/queue-handler.log"
      start_command "ruby queue/handler.rb"
      daemonize true
    end
  end
end
