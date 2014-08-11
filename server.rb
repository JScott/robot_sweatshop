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

def check_payload(payload)
  if payload.nil?
    puts "Stopping. No parser for tool:", params['tool']
    return false
  end
  return true
end

def check_branch(payload)
  unless CONF['branches'].include? payload.branch
    puts "Stopping. '#{payload.branch}' is not on the branch watchlist:", CONF['branches']
    return false
  end
  return true
end

def verify_scripts(scripts)
  missing_scripts = scripts.reject { |script| File.exists? File.expand_path(script) }
  unless missing_scripts.empty?
    puts "Stopping. Couldn't find scripts to run:", missing_scripts
    return false
  end
  return true
end

def verify_payload(payload)
  check_payload(payload) &&
  check_branch(payload)
end

def run_scripts_with(payload)
  CONF['scripts'].each do |path|
    puts "Running #{path}..."
    path = File.expand_path path
    system path
    puts "Script done. (exit status: #{$?.exitstatus})"
  end
end

post '/:tool/payload-for/:job' do
  puts "Received #{params['tool']} payload for #{params['job']}"
  request.body.rewind
  payload = parse_payload params['tool'], request.body.read
  run_scripts_with payload if verify_payload payload
end

exit unless verify_scripts CONF['scripts']
