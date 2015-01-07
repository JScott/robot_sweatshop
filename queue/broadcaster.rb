#!/usr/bin/env ruby
require_relative 'lib/file-queue'
gem 'ezmq'

%w(raw-payload parsed-payload jobs).each do |queue|
  t.push {
    queue: FileQueue.new queue,
    publisher: EZMQ::Publisher.new topic: queue
  }
end

publishers = {}
queues.each do |queue|
  publishers[queue] = EZMQ::Publisher.new topic: queue
end



loop do
  
end
