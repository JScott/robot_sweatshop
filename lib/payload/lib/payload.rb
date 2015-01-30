class Payload
  def self.hash_keys
    %w(author hash branch message repo_slug source_url clone_url)
  end

  def to_hash
    keys = Payload.hash_keys
    values = Payload.hash_keys.map { |method| method(method.to_sym).call }
    [keys, values].transpose.to_h
  end
end