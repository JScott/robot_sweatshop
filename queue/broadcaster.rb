#!/usr/bin/env ruby
require_relative 'lib/file-queue'
require 'ezmq'

queue_data = []
%w(raw-payload parsed-payload jobs).each do |queue|
  queue_data.push({
    queue: FileQueue.new(queue),
    publisher: EZMQ::Publisher.new(topic: queue)
  })
end

loop do
  
end
