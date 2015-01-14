#!/usr/bin/env ruby
require 'ezmq'
require 'json'

def parse(payload, of_format:)
  if File.file? "#{__dir__}/lib/#{of_format}"
    require_relative "lib/#{of_format}"
    Object.const_get("#{of_format.capitalize}Payload").new payload
  else
    nil
  end	
end

def queue(payload)
  hash = payload.to_hash
  client.request "parsed-payload #{JSON.generate hash}"
end

def wait_for_raw_payload
  client = EZMQ::Client.new port: 5556
  subscriber = EZMQ::Subscriber.new port: 5557, topic: 'busy-queues'
  subscriber.listen do |message|
    puts "HEARD #{message}"
    queue = message.gsub 'busy-queues ', ''
    puts "[#{queue}]"
    if queue == 'raw-payload'
      data = client.request queue
      puts "real good! #{data}"
      yield JSON.parse(data)
    end
  end
end

puts "STARTED"
wait_for_raw_payload do |data|
  puts "QUEUEING #{data}"
  payload = parse data['payload'], of_format: data['format']
  queue payload.to_hash if payload
end
