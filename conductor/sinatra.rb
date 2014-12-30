#!/usr/bin/env ruby
require 'sinatra'
require 'yaml'
require_relative 'helpers/job'
require_relative 'lib/payload'

configure do
  config = {
    port: 8080
  }
  config.merge! YAML.load_file File.join(__dir__, 'config.yaml')

  set :port, config[:port]
  set :bind, '0.0.0.0'
end

helpers JobsHelper

get '/' do
  'Everything\'s on schedule!'
end

post '/:tool/payload-for/:job_name' do
  puts "Received #{params['tool']} payload for #{params['job_name']}"
  job = get_job params['job_name']
  payload = parse_payload_from params['tool']
  puts "Payload: #{payload}"
  if job['branches'].include? payload['branch']
    enqueue job, payload
    status 200, 'Payload successfully queued'  
  else
    halt 400, "#{payload['branch']} isn't monitored for #{job['name']}" 
  end
end
