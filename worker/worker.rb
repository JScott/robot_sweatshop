#!/usr/bin/env ruby
require 'ezmq'
require 'json'
require_relative 'lib/script_running'

def unpack(message)
  json = JSON.parse message
  return '', [], {}
  #return json['job_name'], json['scripts'], json['context']
end

def run_scripts(job_name = '', scripts = [], with: {})
  with.each { |key, value| ENV[key.to_s] = value.to_s }
  from_workspace(named: job_name) do
    job['scripts'].each { |command| run command, log: logger }
  end
end

def job_request
  client = EZMQ::Client.new
  client.request
end

claim_job = lambda do |message|
  job_name, scripts, context = unpack job_request
  run job_name, scripts, with: context
end

worker = EZMQ::Subscriber.new action: claim_job#, address: 'tcp://127.0.0.1:5555'
worker.subscribe ''
puts "Listening for work"
worker.listen
