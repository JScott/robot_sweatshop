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

server = EZMQ::Server.new port: 5556
server.listen do |message|
  name, item = message.split ' '
  is_pop_request = item.nil?
  is_pop_request ? pop(name) : push(name, item)
end
