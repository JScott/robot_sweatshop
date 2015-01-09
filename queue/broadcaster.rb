#!/usr/bin/env ruby
require_relative 'lib/file-queue'
require 'ezmq'

publisher = EZMQ::Publisher.new port: 5557#, topic: 'busy-queues'
queues = {}
%w(raw-payload parsed-payload jobs testing).each do |queue|
  queues[queue] = FileQueue.new queue
end

loop do
  queues.each do |queue_name, queue|
    publisher.send queue_name, topic: 'busy-queues' if queue.size > 0
  end
end
