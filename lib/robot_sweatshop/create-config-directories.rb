require 'fileutils'

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
    create_path File.expand_path(value)
  end
end
%w(pidfile_path logfile_path).each do |path|
  p File.expand_path("#{configatron[path]}/gears")
  create_path File.expand_path("#{configatron[path]}/gears")
end
