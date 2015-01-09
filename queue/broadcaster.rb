#!/usr/bin/env ruby
require_relative 'lib/file-queue'
require 'ezmq'

publisher = EZMQ::Publisher.new address: 'tcp://127.0.0.1:5557', topic: ''
queues = {}
%w(raw-payload parsed-payload jobs testing).each do |queue|
  queues[queue.to_sym] = FileQueue.new queue
end

loop do
  queues.each do |queue_name, queue|
    publisher.send queue_name if queue.size > 0
  end
end
