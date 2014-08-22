#!/usr/bin/ruby
file_path = File.expand_path File.dirname(__FILE__)
IO.popen("sidekiq --require #{file_path}/server.rb") do |io|
  while line = io.gets
    puts line
  end
end
