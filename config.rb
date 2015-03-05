require 'fileutils'
require 'configatron'
require 'yaml'

configurations = ["#{__dir__}/config.yaml"]

user_defined_config = File.expand_path '/etc/robot_sweatshop/config.yaml'
configurations.push user_defined_config if File.file? user_defined_config

configurations.each do |config_path|
  hash = YAML.load_file config_path
  configatron.configure_from_hash hash
end

FileUtils.mkdir_p configatron.common.logfile_directory
FileUtils.mkdir_p configatron.common.pidfile_directory
FileUtils.mkdir_p configatron.queue.moneta_directory
