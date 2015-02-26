#!/usr/bin/env ruby
require_relative '../queue-helper'

def parse(payload = '', of_format:)
  of_format = of_format.downcase
  lib_file = "#{__dir__}/lib/#{of_format}.rb"
  if of_format != 'payload' && File.file?(lib_file)
    require_relative lib_file
    Object.const_get("#{of_format.capitalize}Payload").new payload
  else
    puts "Dropping bad format: #{of_format}"
    nil
  end
end

QueueHelper.wait_for_queue('raw-payload') do |data|
  puts "Parsing: #{data}"
  payload = parse data['payload'], of_format: data['format']
  if payload
    hash = { payload: payload.to_hash, job_name: data['job_name'] }
    QueueHelper.enqueue hash, to: 'parsed-payload'
  end
end
