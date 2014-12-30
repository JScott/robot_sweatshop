#!/usr/bin/env ruby

file_path = File.expand_path File.dirname(__FILE__)
command = [
  "/usr/local/bin/sidekiq",
  "--require #{file_path}/lib/queuing.rb",
  "--config #{file_path}/sidekiq.yaml"
]
IO.popen("#{command.join ' '}") do |io|
  while line = io.gets
    puts line
  end
end
