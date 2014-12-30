require 'uri'
require 'json'

class BitbucketPayload
  def initialize(data)
    data = URI.decode_www_form(data)[0][1]
    @data = JSON.parse data || {}
  end

  def latest_commit
    return {} if @data['commits'].nil?
    @data['commits'].last
  end

  def repository
    return {} if @data['repository'].nil?
    @data['repository']
  end

  def author
    self.latest_commit['raw_author']
  end

  def hash
    self.latest_commit['raw_node']
  end

  def branch
    self.latest_commit['branch']
  end

  def message
    self.latest_commit['message']
  end

  def repo_slug
    slug = self.repository['absolute_url']
    slug.nil? ? nil : slug[1...-1]
  end

  def source_url
    return '' if @data['canon_url'].nil? || self.repository.empty? || self.latest_commit.empty?
    base_url = @data['canon_url']
    "#{base_url}/#{self.repo_slug}/commits/#{self.hash}/?at=#{self.branch}"
  end

  def git_commit_data
    data = {}
    ['author', 'hash', 'branch', 'message', 'repo_slug', 'source_url'].each do |method|
      data[method] = self.method(method.to_sym).call
    end
    return data
  end
end
