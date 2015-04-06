require 'fileutils'
require_relative 'config'

CONFIG_DIRECTORIES = [
  'logfile_directory',
  'pidfile_directory',
  'moneta_directory',
  'job_directory',
  'workspace_directory'
]

def set_dir_permissions(on_directory:)
  user = configatron.user
  group = configatron.has_key?(:group) ? configatron.group : 'nogroup'
  begin
    FileUtils.chown_R user, group, on_directory unless user.nil?
  rescue ArgumentError
    puts "Could not set permissions for '#{on_directory}'"
  end
end

CONFIG_DIRECTORIES.each do |directory|
  begin
    FileUtils.mkdir_p configatron[directory]
  rescue Errno::EACCES
    puts "Permission denied to create '#{configatron[directory]}'"
  end
  set_dir_permissions on_directory: configatron[directory] if configatron.has_key? :user
end
