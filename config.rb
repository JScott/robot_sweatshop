require 'fileutils'
require 'configatron'
require 'yaml'

configurations = ["#{__dir__}/config.yaml", "#{__dir__}/config.user.yaml"]
configurations.each do |config_path|
   if File.file? config_path
    hash = YAML.load_file config_path
    configatron.configure_from_hash hash
  end
end

FileUtils.mkdir_p configatron.common.logfile_directory
FileUtils.mkdir_p configatron.common.pidfile_directory
FileUtils.mkdir_p configatron.queue.moneta_directory
