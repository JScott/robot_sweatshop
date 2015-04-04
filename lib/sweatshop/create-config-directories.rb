require 'fileutils'
require 'configatron'
require_relative 'config'

config_directories = [
  'logfile_directory',
  'pidfile_directory',
  'moneta_directory',
  'job_directory',
  'workspace_directory'
]
config_directories.each do |directory|
  # We need a full paths before we get to Eye
  # because Eye's server chdir's to '/'
  configatron[directory] = File.expand_path configatron[directory]

  FileUtils.mkdir_p configatron[directory]
  set_permissions for_directory: configatron[directory]
end

def set_permissions(for_directory:)
  if configatron.common.has_key? :user
    user = configatron.user
    group = configatron.has_key? :group ? configatron.group : 'nogroup'
    FileUtils.chown_R user, group, for_directory unless user.nil?
  end
end
