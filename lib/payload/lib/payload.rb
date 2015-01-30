class Payload
  def self.hash_keys
    %w(author hash branch message repo_slug source_url clone_url)
  end

  def to_hash
    values = Payload.hash_keys.map { |method| method(method.to_sym).call }
    data = [Payload.hash_keys, values].transpose.to_h
    puts "WHAT: #{data}"
    data
  end
end