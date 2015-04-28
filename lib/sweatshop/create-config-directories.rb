require 'fileutils'
require_relative 'config'

def set_dir_permissions(for_path:)
  user = configatron.user
  group = configatron.has_key?(:group) ? configatron.group : 'nogroup'
  begin
    FileUtils.chown_R user, group, for_path unless user.nil?
  rescue ArgumentError
    puts "Could not set permissions for '#{for_path}'"
  end
end

def create_path(path)
  begin
    FileUtils.mkdir_p path
  rescue Errno::EACCES
    puts "Permission denied to create '#{path}'"
  end
end

config = configatron.to_h
config.each do |key, value|
  if key.to_s.match /_directory/
    path = File.expand_path value
    create_path path
    set_dir_permissions for_path: path if configatron.has_key? :user
  end
end
