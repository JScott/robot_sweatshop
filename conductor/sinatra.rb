#!/usr/bin/env ruby
require 'sinatra'
require 'yaml'
require_relative 'lib/payload'
require_relative '../worker/lib/queuing'

configure do
  config = {
    port: 8080
  }
  config.merge! YAML.load_file File.join(__dir__, 'config.yaml')

  set :port, config[:port]
  set :bind, '0.0.0.0'
  #set :jobs, get_job_data('./jobs') 
end

get '/' do
  'Everything\'s on schedule!'
end

post '/:tool/payload-for/:job' do
  puts "Received #{params['tool']} payload for #{params['job']}"
  puts catch (:error) {
    reject_job params['job'] unless settings.jobs.include? params['job']
    job = settings.jobs[params['job']]

    request.body.rewind
    parse = parser_for params['tool']
    payload = parse.new request.body.read
    verify_payload payload, job['branches']

    environment_vars = payload.to_hash
    environment_vars.merge! job['environment'] unless job['environment'].nil?
    enqueue_scripts params['job'], environment_vars, job['scripts']
  }
  status 200
end
