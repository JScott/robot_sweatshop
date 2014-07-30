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
  commit = bitbucket['commits'].last
  repo = bitbucket['repository']
  source_url = "https://bitbucket.org#{repo['absolute_url']}src/#{commit['raw_node']}/?at=#{commit['branch']}"
  parameters = [
    "token=#{CONF['token']}",
    "GIT_AUTHOR=#{commit['raw_author']}",
    "GIT_HASH=#{commit['raw_node']}",
    "GIT_MESSAGE=#{commit['message']}",
    "GIT_REPO=#{repo['absolute_url']}".
    "GIT_BRANCH=#{commit['branch']}",
    "GIT_SOURCE_URL=#{source_url}"
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
