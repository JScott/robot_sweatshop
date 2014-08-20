#!/usr/bin/ruby
require 'sinatra'
require 'rdiscount'
require_relative 'helpers/output'
require_relative 'helpers/payload'
require_relative 'helpers/scripts'
require_relative 'helpers/configs'
require_relative 'helpers/resque'

configure do
  server_config = read_config 'config.yaml'
  set_log_file server_config
  set_pid_file server_config
  configure_resque
  set :port, 6381
  set :bind, '0.0.0.0'
  set :jobs, get_job_data('./jobs') 
end

get '/' do
  markdown = File.read 'README.md'
  RDiscount.new(markdown).to_html
end

post '/:tool/payload-for/:job' do
  puts "Received #{params['tool']} payload for #{params['job']}"
  puts catch (:error) {
    reject_job params['job'] unless settings.jobs.include? params['job']
    job = settings.jobs[params['job']]

    request.body.rewind
    parse = parser_for params['tool']
    payload = parse.new request.body.read
    verify_payload payload, job['branches']

    enqueue_scripts job_name, job, payload
#    Thread.new(params['job'], job, payload) { |job_name, job_data, payload|
#      set_environment_variables payload
#      job_data['environment'].each { |key, value| ENV[key] = value }
#      run_scripts job_name, job_data['scripts'], payload
#    }
  }
  status 200
end
