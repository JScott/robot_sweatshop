require 'uri'
require 'json'

class BitbucketPayload
  def initialize(data)
    data = URI.decode_www_form(data)[0][1]
    @data = JSON.parse data
  end

  def latest_commit
    @data['commits'].last
  end

  def repository
    @data['repository']
  end

  def source_url
    base_url = @data['canon_url']
    repo_slug = self.repository['absolute_url']
    hash = self.latest_commit['raw_node']
    branch = self.latest_commit['branch']
    "#{base_url}#{repo_slug}src/#{hash}/?at=#{branch}"
  end  
end


#  commit = bitbucket['commits'].last
#  repo = bitbucket['repository']
#  source_url = URI.escape "https://bitbucket.org#{repo['absolute_url']}src/#{commit['raw_node']}/?at=#{commit['branch']}"
#  parameters = [
#    "token=#{settings.jenkins['token']}",
#    "GIT_AUTHOR=#{commit['raw_author']}",
#    "GIT_HASH=#{commit['raw_node']}",
#    "GIT_MESSAGE=#{commit['message']}",
#    "GIT_REPO=#{repo['absolute_url']}",
#    "GIT_BRANCH=#{commit['branch']}",
#    "GIT_SOURCE_URL=#{source_url}"
#  ].join '&'
