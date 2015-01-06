require 'uri'
require 'json'

# Parser for Bitbucket webhook payloads.
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
    return {} if latest_commit['raw_author'].nil?
    name, email = latest_commit['raw_author'].split(/\s+</)
    email.slice! '>' unless email.nil?
    {
      'name' => name,
      'email' => email || '',
      'username' => latest_commit['author']
    }
  end

  def clone_url
    "#{ @data['canon_url'] }#{ repository['absolute_url'] }"
  end

  def hash
    latest_commit['raw_node']
  end

  def branch
    latest_commit['branch']
  end

  def message
    latest_commit['message']
  end

  def repo_slug
    slug = repository['absolute_url']
    slug.nil? ? nil : slug[1...-1]
  end

  def source_url
    return '' if @data['canon_url'].nil? || repository.empty? || latest_commit.empty?
    base_url = @data['canon_url']
    "#{base_url}/#{repo_slug}/commits/#{hash}/?at=#{branch}"
  end

  def git_commit_data
    data = {}
    %w(author hash branch message repo_slug source_url clone_url).each do |method|
      data[method] = method(method.to_sym).call
    end
    data
  end
end
