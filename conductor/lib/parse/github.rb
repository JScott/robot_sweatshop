require 'json'

# Parser for Github webhook payloads.
class GithubPayload
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

  def git_commit_data
    data = {}
    %w(author hash branch message repo_slug source_url clone_url).each do |property|
      data[property] = method(property.to_sym).call
    end
    data
  end
end
