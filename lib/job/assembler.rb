#!/usr/bin/env ruby
require 'ezmq'
require 'json'
require 'yaml'

JOB_DIR = "#{__dir__}/../../jobs"

@client = EZMQ::Client.new port: 5556
@input_queue = 'parsed-payload'
@output_queue = 'jobs'

def assemble_job(from_payload: data)
  job_config = YAML.load_file "#{JOB_DIR}/#{data['job_name']}"
  if job_config['branch_whitelist'].include? data['payload']['branch']
    {
      commands: job_config['commands'],
      context: job_config['environment'].merge data['payload']
    }
  else
    nil
  end
end

def queue(assembled_job)
  @client.request "#{@output_queue} #{JSON.generate assembled_job}"
end

def dequeue
  @client.request @input_queue
end

def wait_for_parsed_payload
  subscriber = EZMQ::Subscriber.new port: 5557, topic: 'busy-queues'
  subscriber.listen do |message|
    if message == @input_queue
      data = dequeue
      yield data unless data.empty?
    end
  end
end

wait_for_parsed_payload do |data|
  begin
    data = JSON.parse data
  rescue JSON::ParserError => e
    data = nil
  end
  unless data.nil?
    puts "Assembling: #{data}"
    assembled_job = assemble_job from_payload: data
    queue assembled_job if assembled_job
  end
end
