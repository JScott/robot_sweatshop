require 'json'
require_relative 'payload'

# A parser for Github payload data
class GithubPayload < Payload
  def initialize(payload)
    @payload = JSON.parse payload || {}
  end

  def commit
    @payload['head_commit'] || {}
  end

  def repository
    @payload['repository'] || {}
  end

  def clone_url
    repository['clone_url'] || ''
  end

  def author
    commit['author']
  end

  def hash
    commit['id'] || {}
  end

  def branch
    @payload['ref'] || ''
  end

  def message
    commit['message'] || ''
  end

  def repo_slug
    repository['full_name'] || ''
  end

  def source_url
    head_commit['url'] || ''
  end
end
