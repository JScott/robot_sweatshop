require 'fileutils'
require_relative 'config'

CONFIG_DIRECTORIES = [
  'logfile_directory',
  'pidfile_directory',
  'moneta_directory',
  'job_directory',
  'workspace_directory'
]

def set_dir_permissions(on:)
  user = configatron.user
  group = configatron.has_key? :group ? configatron.group : 'nogroup'
  FileUtils.chown_R user, group, for_directory unless user.nil?
end

CONFIG_DIRECTORIES.each do |directory|
  FileUtils.mkdir_p configatron[directory]
  set_dir_permissions on: configatron[directory] if configatron.has_key? :user
end
