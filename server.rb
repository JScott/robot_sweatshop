#!/usr/bin/ruby
require 'yaml'
require 'sinatra'
require 'rdiscount'
require_relative 'helpers/payload'
require_relative 'helpers/scripts'

dir = File.expand_path File.dirname(__FILE__)
config = YAML.load_file("#{dir}/config.yaml")

set :port, 6381
set :bind, '0.0.0.0'
set :branches, config['branches']
set :scripts, config['scripts']
verify_scripts settings.scripts

get '/' do
  markdown = File.read 'README.md'
  RDiscount.new(markdown).to_html
end

post '/:tool/payload-for/:job' do
  puts "Received #{params['tool']} payload for #{params['job']}"
  request.body.rewind
  puts catch (:error) {
    parse = parser_for params['tool']
    payload = parse.new request.body.read
    verify_payload payload, settings.branches

    Thread.new {
      set_environment_variables payload
      run_scripts params['job'], settings.scripts, payload
    }
  }
  status 200
end
