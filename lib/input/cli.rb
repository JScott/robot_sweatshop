#!/usr/bin/env ruby
require 'ezmq'
require 'json'
require 'json'

job_name = ARGV[0]
begin
  environment = JSON.parse ARGV[1]
rescue JSON::ParserError
  raise 'The environment must be passed as a JSON string'
end

raise 'Please provide a job name to run' unless job_name

hash = {
  payload: environment,
  format: 'cli',
  job_name: job_name
}
client = EZMQ::Client.new port: 5556
client.request "raw-payload #{JSON.generate hash}"
