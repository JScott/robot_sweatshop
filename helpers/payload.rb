require_relative 'output'
require_relative '../parse/bitbucket'

def parser_for(tool)
  case tool
  when 'bitbucket'
    BitbucketPayload
  else
    throw_error "Stopping. No parser for tool:\n#{tool}"
  end
end

def verify_payload(payload, branch_watchlist)
  unless branch_watchlist.include? payload.branch
    throw_error "Stopping. '#{payload.branch}' is not on the branch watchlist:\n#{branch_watchlist}"
  end
end

def set_environment_variables(payload)
  {
    'CI_GIT_AUTHOR' => 'author',
    'CI_GIT_HASH' => 'hash',
    'CI_GIT_BRANCH' => 'branch',
    'CI_GIT_MESSAGE' => 'message',
    'CI_GIT_REPO_SLUG' => 'repo_slug',
    'CI_GIT_SOURCE_URL' => 'source_url'
  }.each do |key, method|
    ENV[key] = payload.send(method)
  end
end
