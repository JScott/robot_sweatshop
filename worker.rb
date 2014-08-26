#!/usr/bin/ruby
file_path = File.expand_path File.dirname(__FILE__)
command = [
  "sidekiq",
  "--require #{file_path}/server.rb",
  "--config #{file_path}/sidekiq.yaml"
]
IO.popen("#{command.join ' '}") do |io|
  while line = io.gets
    puts line
  end
end
