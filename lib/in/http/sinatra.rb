#!/usr/bin/env ruby
require 'sinatra'
#require 'yaml'
require 'ezmq'
require 'json'
#require_relative 'lib/payload'
#require_relative 'lib/job'
#require_relative 'helpers/data'

configure do
  config = {
    port: 80
  }

  set :port, config[:port]
  set :bind, '0.0.0.0'
  set :output_queue, 'raw-payload'
end

#helpers DataHelper

get '/' do
  'Everything\'s on schedule!'
end

post '/:tool/payload-for/:job_name' do
  puts "Received #{params['tool']} payload for #{params['job_name']}"
  client = EZMQ::Client.new port: 5556
  hash = { }
  client.request "#{settings.output_queue} #{JSON.generate hash}"
end
