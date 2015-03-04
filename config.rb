require 'configatron'

configatron.common do |common|
  common.pidfile_directory = '/var/run/robot_sweatshop'
  common.logfile_directory = '/var/log/robot_sweatshop'
  common.eye_config_file = 'robot_sweatshop.production.eye'
  # TODO: ports
end

configatron.input do |input|
  input.http.port = 8080
  input.http.bind = '0.0.0.0'
end

configatron.queue do |queue|
  queue.moneta_directory = '/var/db/robot_sweatshop'
end
