#!/usr/bin/ruby
require 'sinatra'
require 'rdiscount'
require_relative 'parse/bitbucket'

set :port, 6381
set :bind, '0.0.0.0'

conf = YAML.load_file('config.yaml')
conf.each do |key, value|
  set key.to_sym, value
end

get '/' do
  markdown = File.read 'README'
  RDiscount.new(markdown).to_html
end

post '/:tool/payload-for/:job' do
  request.body.rewind
  payload = case params['tool']
  when 'bitbucket'
    BitbucketPayload.new request.body.read
  else
    ''
  end
  raise "ERROR: no parser for #{params['tool']} payload for #{params['job']}" if payload.empty?

  
end
