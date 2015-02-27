#!/usr/bin/env ruby
require_relative 'lib/moneta-queue'

@queues = []
[ARGV[0], "mirror-#{ARGV[0]}"].each do |queue_name|
  @queues.push(name: queue_name, queue: MonetaQueue.new(queue_name))
end

loop do
  system 'clear'
  @queues.each do |q|
    puts "Queue: #{q[:name]}"
    puts "Size: #{q[:queue].size}", "#{'|' * q[:queue].size}"
    puts q[:queue].inspect
    puts
  end
  sleep 0.5
end
