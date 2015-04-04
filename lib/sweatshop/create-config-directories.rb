require 'fileutils'
require 'configatron'
require 'yaml'
require_relative 'config'

CONFIG_DIRECTORIES = [
  'logfile_directory',
  'pidfile_directory',
  'moneta_directory',
  'job_directory',
  'workspace_directory'
]

def set_permissions(for_directory:)
  if configatron.has_key? :user
    user = configatron.user
    group = configatron.has_key? :group ? configatron.group : 'nogroup'
    FileUtils.chown_R user, group, for_directory unless user.nil?
  end
end

CONFIG_DIRECTORIES.each do |directory|
  # We need a full paths before we get to Eye
  # because Eye's server chdir's to '/'
  p configatron[directory]
  configatron[directory] = File.expand_path configatron[directory]

  p configatron[directory]
  FileUtils.mkdir_p configatron[directory]
  p Dir.exists?(configatron[directory])
  set_permissions for_directory: configatron[directory]
end

# Eye needs this from YAML, not configatron
File.write('/tmp/.robot_sweatshop.eye-config.yaml', configatron.to_h.to_yaml)
