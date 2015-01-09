#!/usr/bin/env ruby
require_relative 'lib/file-queue'
require 'ezmq'

def push(name, item)
  queue = FileQueue.new name
  queue.push item
  queue.size.to_s
end

def pop(name)
  queue = FileQueue.new name
  queue.pop
end

handler = lambda do |message|
  name, item = message.split ' '
  value = item.nil? ? pop(name) : push(name, item)
  value
end

server = EZMQ::Server.new provides: handler, address: 'tcp://127.0.0.1:5556'
server.listen
