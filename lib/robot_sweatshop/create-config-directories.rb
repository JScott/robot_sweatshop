require 'fileutils'

def create_path(path)
  FileUtils.mkdir_p path
rescue Errno::EACCES
  puts "Permission denied to create '#{path}'"
end

config = configatron.to_h
config.each do |key, value|
  create_path File.expand_path(value) if key.to_s.match(/_path/)
end
