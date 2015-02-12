#!/usr/bin/env ruby
require 'ezmq'
require 'json'

@client = EZMQ::Client.new port: 5556
@input_queue = 'raw-payload'
@output_queue = 'parsed-payload'

def parse(payload, of_format:)
  lib_file = "#{__dir__}/lib/#{of_format.downcase}.rb"
  if File.file? lib_file
    require_relative lib_file
    Object.const_get("#{of_format.capitalize}Payload").new payload
  else
    nil
  end	
end

def queue(payload, for_job:)
  hash = { payload: payload.to_hash, job_name: for_job }
  @client.request "#{@output_queue} #{JSON.generate hash}"
end

def dequeue
  @client.request @input_queue
end

def wait_for_raw_payload
  subscriber = EZMQ::Subscriber.new port: 5557, topic: 'busy-queues'
  subscriber.listen do |message|
    if message == @input_queue
      data = dequeue
      yield data unless data.empty?
    end
  end
end

wait_for_raw_payload do |data|
  begin
    data = JSON.parse data
  rescue JSON::ParserError => e
    data = nil
  end
  unless data.nil?
    puts "Parsing: #{data}"
    payload = parse data['payload'], of_format: data['format']
    queue payload, for_job: data['job_name'] if payload
  end
end
