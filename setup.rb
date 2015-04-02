require 'fileutils'
require 'configatron'
require_relative 'config'

config_directories = [
  configatron.common.logfile_directory,
  configatron.common.pidfile_directory,
  configatron.common.user_config_directory,
  configatron.queue.moneta_directory,
  configatron.assembler.job_directory,
  configatron.worker.workspace_directory
]
config_directories.each do |directory|
  FileUtils.mkdir_p directory unless Dir.exists? directory
  FileUtils.chown_R configatron.common.user, configatron.common.group, directory
end
