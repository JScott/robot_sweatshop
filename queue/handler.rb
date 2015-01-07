#!/usr/bin/env ruby
require_relative 'lib/file-queue'
require 'ezmq'

# TODO: be flexible in queue names. just make it if it isn't there!

@queues = {}

def create_queue(name)
  @queues[name] ||= FileQueue.new name
end

handler = lambda do |message|
  name, item = message.split ' '
  create_queue name
  if item.nil?
    @queues[name].pop
  else
    @queues[name].push item
    @queues[name].size.to_s
  end
end

at_exit do
  @queues.each { |name, queue| queue.close }
end

server = EZMQ::Server.new provides: handler
server.listen
