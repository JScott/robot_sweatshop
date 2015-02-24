#!/usr/bin/env ruby
require 'sinatra'
require 'ezmq'
require 'json'

configure do
  set :port, 80
  set :bind, '0.0.0.0'
  set :output_queue, 'raw-payload'
end

get '/' do
  'Everything\'s on schedule!'
end

post '/:format/payload-for/:job_name' do
  puts "Received #{params['format']} payload for #{params['job_name']}"
  request.body.rewind
  hash = {
    payload: request.body.read,
    format: params['format'],
    job_name: params['job_name']
  }
  client = EZMQ::Client.new port: 5556
  client.request "#{settings.output_queue} #{JSON.generate hash}"
end
