#!/usr/bin/env ruby
require 'sinatra'
require 'yaml'
require_relative 'lib/payload'
require_relative 'lib/job'
require_relative 'helpers/data'

configure do
  config = {
    port: 8080
  }
  config.merge! YAML.load_file File.join(__dir__, 'config.yaml')

  set :port, config[:port]
  set :bind, '0.0.0.0'
end

helpers DataHelper

get '/' do
  'Everything\'s on schedule!'
end

post '/:tool/payload-for/:job_name' do
  puts "Received #{params['tool']} payload for #{params['job_name']}"
  job = get_job params['job_name']
  payload = parse_payload_from params['tool']
  puts payload.git_commit_data
  if job['branches'].nil? || job['branches'].include?(payload.branch)
    enqueue job, payload
    status 200
  else
    message = "#{job['name']} doesn't monitor branch '#{payload.branch}'"
    puts message
    halt 400, message
  end
end
