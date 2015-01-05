require_relative 'parse/bitbucket'

def parser_for(tool)
  case tool
  when 'bitbucket'
    BitbucketPayload
  when 'github'
    GithubPayload
  else
    nil
  end
end
