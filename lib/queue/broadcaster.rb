#!/usr/bin/env ruby
require_relative 'lib/moneta-queue'
require 'ezmq'

publisher = EZMQ::Publisher.new port: 5557
queues = {}
MonetaQueue.watched_queues.each do |queue|
  queues[queue] = MonetaQueue.new queue
end

@wait_time = ARGV[0].to_f

loop do
  queues.each do |queue_name, queue|
    publisher.send queue_name, topic: 'busy-queues' if queue.size > 0
  end
  sleep @wait_time unless @wait_time == 0
end
