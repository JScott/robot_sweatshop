require 'fileutils'
require 'configatron'
require_relative 'common'
require_relative '../../config'

config_directories = [
  configatron.common.logfile_directory,
  configatron.common.pidfile_directory,
  configatron.common.user_config_directory,
  configatron.queue.moneta_directory,
  configatron.assembler.job_directory,
  configatron.worker.workspace_directory
]
config_directories.each do |directory|
  user = configatron.common.user
  group = configatron.common.group
  if Dir.exists? directory
    notify :info, "'#{directory}' already exists"
  else
    FileUtils.mkdir_p directory
    notify :success, "Created '#{directory}' and set owner as #{user}:#{group}"
  end
  FileUtils.chown_R user, group, directory
  notify :success, "Recursively set owner of '#{directory}' as #{user}:#{group}\n\n"
end
