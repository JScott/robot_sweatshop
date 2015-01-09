#!/usr/bin/env ruby
require_relative 'lib/file-queue'
require 'ezmq'

queue_data = []
%w(raw-payload parsed-payload jobs).each do |queue|
  queue_data.push({
    queue: FileQueue.new(queue),
    publisher: EZMQ::Publisher.new(topic: queue, address 'tcp://127.0.0.1:5557')
  })
end

loop do
  
end
