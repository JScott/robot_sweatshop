#!/usr/bin/ruby
require 'sinatra'
require 'rdiscount'
require 'yaml'
require 'httparty'
require 'uri'

CONF = YAML.load_file 'jenkins_config.yaml'

set :port, 6381
set :bind, '0.0.0.0'

get '/' do
  markdown = File.read 'README'
  RDiscount.new(markdown).to_html
end

def git_push_url(bitbucket_data, job_name)
  authors = []
  bitbucket_data['commits'].each do |commit|
    authors.push commit['raw_author']
  end
  parameters = [
    "token=#{CONF['token']}",
    "GIT_AUTHOR=#{authors.uniq.join ', '}",
    "GIT_HASH=#{bitbucket_data['commits'].last['raw_node']}",
    "GIT_MESSAGE=#{bitbucket_data['commits'].last['message']}",
    "GIT_REPO=#{bitbucket_data['repository']['absolute_url']}"
  ].join '&'
  puts parameters
  URI.escape "http://#{CONF['host']}:#{CONF['port']}/job/#{job_name}/buildWithParameters?#{parameters}"
end

post '/:tool/payload-for/:job' do
  request.body.rewind
  case params['tool']
  when 'bitbucket'
    git_data = URI.decode_www_form(request.body.read)[0][1]
    git_data = JSON.parse git_data
    HTTParty.get git_push_url(git_data, params['job'])
  else
    puts 'Error: unknown tool called'
  end
end
