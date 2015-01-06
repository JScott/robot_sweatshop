#!/usr/bin/env ruby
command = [
  '/usr/local/bin/sidekiq',
  "--require #{__dir__}/lib/queuing.rb",
  "--config #{__dir__}/sidekiq.yaml"
]
IO.popen("#{command.join ' '}") do |io|
  while line = io.gets
    puts line
  end
end
