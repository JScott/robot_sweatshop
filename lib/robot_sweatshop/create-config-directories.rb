require 'fileutils'
require_relative 'config'

def create_path(path)
  begin
    FileUtils.mkdir_p path
  rescue Errno::EACCES
    puts "Permission denied to create '#{path}'"
  end
end

config = configatron.to_h
config.each do |key, value|
  if key.to_s.match /_path/
    path = File.expand_path value
    create_path path
  end
end
