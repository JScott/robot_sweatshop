require 'json'
require_relative 'payload'

# A parser for arbitrary data
class CustomPayload < Payload
  def initialize(payload)
    @payload = JSON.parse payload || {}
  end

  def to_hash
    @payload
  end
end
