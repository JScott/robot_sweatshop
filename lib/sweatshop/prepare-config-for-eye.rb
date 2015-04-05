require_relative 'config'

configatron.eye.working_directory = Dir.pwd
configatron.eye.log_file = "#{File.expand_path configatron.logfile_directory}/eye.log"

# configatron.eye.config = '/tmp/.robot_sweatshop.eye-config.yaml'
# eye_config = {
#   working_directory: Dir.pwd,
#   eye_log_path: "#{}"
# }
# File.write(configatron.eye.config, eye_config.to_yaml)
