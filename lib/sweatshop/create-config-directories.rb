require 'fileutils'
require 'configatron'
require_relative 'config'

config_directories = [
  configatron.common.logfile_directory,
  configatron.common.pidfile_directory,
  configatron.queue.moneta_directory,
  configatron.assembler.job_directory,
  configatron.worker.workspace_directory
]
config_directories.each do |directory|
  directory = File.expand_path directory
  FileUtils.mkdir_p directory
  if configatron.common.has_key? :user
    user = configatron.common.user
    user = configatron.common.has_key? :group ? configatron.common.group : 'nogroup'
    FileUtils.chown_R user, group, directory unless user.nil?
  end
end
