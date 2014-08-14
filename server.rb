#!/usr/bin/ruby
require 'yaml'
require 'sinatra'
require 'rdiscount'
require_relative 'helper'

set :port, 6381
set :bind, '0.0.0.0'

CONF = YAML.load_file('config.yaml')
verify_scripts CONF['scripts']

get '/' do
  markdown = File.read 'README'
  RDiscount.new(markdown).to_html
end

post '/:tool/payload-for/:job' do
  puts "Received #{params['tool']} payload for #{params['job']}"
  request.body.rewind
  parse = parser_for params['tool']
  payload = parse.new request.body.read
  verify_payload payload, CONF['branches']
  run_scripts params['job'], CONF['scripts'], payload
end
