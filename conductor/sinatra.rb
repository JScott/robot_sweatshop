#!/usr/bin/env ruby
require 'sinatra'
require 'yaml'
require_relative 'lib/payload'
require_relative 'lib/jobs'
require_relative '../worker/lib/queuing'

configure do
  config = {
    port: 8080
  }
  config.merge! YAML.load_file File.join(__dir__, 'config.yaml')

  set :port, config[:port]
  set :bind, '0.0.0.0'
end

get '/' do
  'Everything\'s on schedule!'
end

post '/:tool/payload-for/:job' do
  jobs = get_job_data
  puts "Received #{params['tool']} payload for #{params['job']}"
  halt 404, "Unknown job: #{params['job']}" unless jobs.include? params['job']
  job = params['job']

  request.body.rewind
  parse = parser_for params['tool']
  halt 404, "Unknown tool: #{params['tool']}" if parse.nil?
  payload = parse.new request.body.read
  #verify_payload payload, job['branches']
  
  data = payload.to_hash #TODO: rename git_data
  data.merge! job['environment'] unless job['environment'].nil?
  RunScriptWorker.perform_async params['job'], job['scripts'], with_environment_vars: data
  #TODO: rename with_environment_vars. it's all gross how this is called
  
  status 200, 'Payload successfully queued'
end
