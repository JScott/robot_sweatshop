require 'fileutils'
require 'configatron'
require 'yaml'

configurations = [
  "#{__dir__}/config.yaml",
  "#{__dir__}/config.user.yaml",
  "/etc/robot_sweatshop/config.yaml"
]
configurations.each do |config_path|
  if File.file? config_path
    hash = YAML.load_file config_path
    configatron.configure_from_hash hash
  end
end

config_directories = [
  configatron.common.logfile_directory,
  configatron.common.pidfile_directory,
  configatron.queue.moneta_directory
]
config_directories.each do |directory|
  FileUtils.mkdir_p directory unless Dir.exists? directory
end
