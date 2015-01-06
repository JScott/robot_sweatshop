#!/usr/bin/env ruby
require 'ezmq'
require 'json'

queue = []
queue_manager = EZMQ::Server.new
queue_manager.listen

worker = EZMQ::Subscriber.new action: claim_job#, address: 'tcp://127.0.0.1:5555'
worker.subscribe ''
puts "Listening for work"
worker.listen
