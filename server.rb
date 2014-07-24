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

def git_push_url(bitbucket_data)
  parameters = [
    "token=#{CONF['token']}",
    "GIT_AUTHOR=#{bitbucket_data['commits'].last['raw_author']}",
    "GIT_HASH=#{bitbucket_data['commits'].last['raw_node']}",
    "GIT_MESSAGE=#{bitbucket_data['commits'].last['message']}",
    "GIT_REPO=#{bitbucket_data['repository']['absolute_url']}"
  ].join '&'
  return URI.escape "http://#{CONF['host']}:#{CONF['port']}/job/#{params['job']}/buildWithParameters?#{parameters}"
end

post '/bitbucket-payload-for/:job' do
  request.body.rewind
  git_data = URI.decode_www_form(request.body.read)[0][1]
  git_data = JSON.parse git_data
  puts git_push_url(git_data)
  HTTParty.get git_push_url(git_data)
end
