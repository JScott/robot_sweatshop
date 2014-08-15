require_relative '../parse/bitbucket'

def parser_for(tool)
  case tool
  when 'bitbucket'
    BitbucketPayload
  else
    raise "Stopping. No parser for tool:\n#{tool}"
  end
end

def verify_payload(payload, branch_watchlist)
  unless branch_watchlist.include? payload.branch
    raise "Stopping. '#{payload.branch}' is not on the branch watchlist:\n#{branch_watchlist}"
  end
end
