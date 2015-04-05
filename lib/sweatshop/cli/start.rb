require 'yaml'
require_relative '../config'

def store_working_directory
  eye_config = {
    log_file: File.expand_path("#{configatron.logfile_directory}/eye.log"),
    working_directory: Dir.pwd
  }
  File.write('/tmp/.robot_sweatshop-eye-config.yaml', eye_config.to_yaml)
end

def start_sweatshop(for_environment:)
  store_working_directory
  eye_config = File.expand_path "#{__dir__}/../../../robot_sweatshop.#{for_environment}.eye"
  output = `eye load #{eye_config}`
  if $?.exitstatus != 0
    notify :failure, output
  else
    notify :success, "Robot Sweatshop loaded with a #{for_environment} configuration"
    notify :info, `eye restart robot_sweatshop`
    puts 'Check \'eye --help\' for more info on debugging'
  end
end
