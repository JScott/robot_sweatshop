#!/usr/bin/env ruby
require_relative 'lib/file-queue'
require 'ezmq'

# TODO: be flexible in queue names. just make it if it isn't there!

@queues = {
  raw_payloads: FileQueue.new('raw-payloads'),
  parsed_payloads: FileQueue.new('parsed-payloads'),
  jobs: FileQueue.new('jobs')
}

handler = lambda do |message|
  queue, item = message.split ' '
  if item.nil?
    @queues[queue.to_sym].pop
  else
    @queues[queue.to_sym].push item
    @queues[queue.to_sym].size.to_s
  end
end

server = EZMQ::Server.new provides: handler
server.listen
