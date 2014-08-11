#!/usr/bin/ruby
require 'yaml'
require 'sinatra'
require 'rdiscount'
require_relative 'parse/bitbucket'

set :port, 6381
set :bind, '0.0.0.0'

CONF = YAML.load_file('config.yaml')

get '/' do
  markdown = File.read 'README'
  RDiscount.new(markdown).to_html
end

def parser_for(tool)
  case tool
  when 'bitbucket'
    BitbucketPayload
  else
    nil
  end
end

def parse_payload(tool, data)
  parse = parser_for params['tool']
  parse.new data
end

def verified(payload)
  if payload.nil?
    puts "Stopping. No parser for #{params['tool']}"
    return false
  end

  unless CONF['branches'].include? payload.branch
    puts "Stopping. '#{payload.branch}' is not in our branch watchlist:", "#{CONF['branches']}"
    return false
  end

  true
end

def run_scripts_with(payload)
  CONF['scripts'].each do |path|
    puts "Running #{File.expand_path path}..."
  end
end

post '/:tool/payload-for/:job' do
  puts "Received #{params['tool']} payload for #{params['job']}"
  request.body.rewind
  payload = parse_payload params['tool'], request.body.read
  run_scripts_with payload if verified payload
end
