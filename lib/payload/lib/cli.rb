require 'uri'
require 'json'
require_relative 'payload'

# A parser for Bitbucket payload data
class BitbucketPayload < Payload
  def to_hash
    {}
  end
end
