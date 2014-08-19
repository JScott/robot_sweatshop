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

unless config['log_file'].nil?
  log = File.new config['log_file'], 'a+'
  STDOUT.reopen log
  STDOUT.sync = true
  STDERR.reopen log
  STDERR.sync = true
end
unless config['pid_file'].nil?
  File.open config['pid_file'], 'w' do |f|
    f.write Process.pid
  end
end

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

    Thread.new(params['job'], settings.scripts, payload) { |job, scripts, payload|
      set_environment_variables payload
      config['environment'].each { |key, value| ENV[key] = value }
      run_scripts job, scripts, payload
    }
  }
  status 200
end
