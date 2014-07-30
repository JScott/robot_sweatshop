#!/usr/bin/ruby
require 'sinatra'
require 'rdiscount'
require 'yaml'
require 'httparty'
require 'uri'

set :port, 6381
set :bind, '0.0.0.0'

configure do
  conf = YAML.load_file('config.yaml')
  conf.each do |key, value|
    set key.to_sym, value
  end
end

get '/' do
  markdown = File.read 'README'
  RDiscount.new(markdown).to_html
end

def git_push_url(bitbucket, job_name)
  commit = bitbucket['commits'].last
  return '' unless settings.branches.include? commit['branch']
  repo = bitbucket['repository']
  source_url = URI.escape "https://bitbucket.org#{repo['absolute_url']}src/#{commit['raw_node']}/?at=#{commit['branch']}"
  parameters = [
    "token=#{settings.jenkins['token']}",
    "GIT_AUTHOR=#{commit['raw_author']}",
    "GIT_HASH=#{commit['raw_node']}",
    "GIT_MESSAGE=#{commit['message']}",
    "GIT_REPO=#{repo['absolute_url']}",
    "GIT_BRANCH=#{commit['branch']}",
    "GIT_SOURCE_URL=#{source_url}"
  ].join '&'
  URI.escape "http://#{settings.jenkins['host']}:#{settings.jenkins['port']}/job/#{job_name}/buildWithParameters?#{parameters}"
end

post '/:tool/payload-for/:job' do
  request.body.rewind
  url = case params['tool']
  when 'bitbucket'
    git_data = URI.decode_www_form(request.body.read)[0][1]
    git_data = JSON.parse git_data
    git_push_url(git_data, params['job'])
  else
    puts 'Error: unknown tool called'
    ''
  end

  if url.empty?
    puts "Payload ignored:\n#{git_data}"
  else
    puts "Requesting:\n#{url}"
    HTTParty.get url
  end
end
