require 'fileutils'
require 'configatron'
require_relative 'config'

config_directories = [
  configatron.logfile_directory,
  configatron.pidfile_directory,
  configatron.moneta_directory,
  configatron.job_directory,
  configatron.workspace_directory
]
config_directories.each do |directory|
  directory = File.expand_path directory
  FileUtils.mkdir_p directory
  if configatron.common.has_key? :user
    user = configatron.user
    group = configatron.has_key? :group ? configatron.group : 'nogroup'
    FileUtils.chown_R user, group, directory unless user.nil?
  end
end
