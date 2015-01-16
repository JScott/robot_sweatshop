#!/usr/bin/env ruby

# Still busy ripping apart payload/parser and stealing the general architecture

require 'ezmq'
require 'json'

JOB_DIR = "#{__dir__}/../../jobs"

@client = EZMQ::Client.new port: 5556

def assemble(payload, of_format:)
  lib_file = "#{__dir__}/lib/#{of_format.downcase}.rb"
     puts "#{lib_file} - #{File.file? lib_file}"
  if File.file? lib_file
    require_relative lib_file
    Object.const_get("#{of_format.capitalize}Payload").new payload
  else
    nil
  end	
end

def queue(payload)
  hash = payload.to_hash
  @client.request "parsed-payload #{JSON.generate hash}"
end

def dequeue
  @client.request 'raw-payload'
end

def wait_for_raw_payload
  subscriber = EZMQ::Subscriber.new port: 5557, topic: 'busy-queues'
  subscriber.listen do |message|
    queue = message.gsub 'busy-queues ', ''
    if queue == 'raw-payload'
      data = dequeue
      yield data unless data.empty?
    end
  end
end

wait_for_raw_payload do |data|
     puts "Heard: #{data.inspect}"
  data = JSON.parse data
  payload = parse data['payload'], of_format: data['format']
     puts payload.inspect
  queue payload if payload
end
