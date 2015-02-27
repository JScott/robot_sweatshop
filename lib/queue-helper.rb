require 'ezmq'
require 'json'

# A collection of common methods for queue interactions with EZMQ
module QueueHelper
  @@client = EZMQ::Client.new port: 5556

  def self.dequeue(queue_name = 'default')
    data = @@client.request queue_name
    begin
      JSON.parse data
    rescue JSON::ParserError
      nil
    end
  end

  def self.enqueue(object = {}, to: 'default')
    @@client.request "#{to} #{JSON.generate object}"
  end

  def self.wait_for(queue_name = 'default')
    puts "Waiting for messages on #{queue_name}"
    subscriber = EZMQ::Subscriber.new port: 5557, topic: 'busy-queues'
    subscriber.listen do |message|
      if message == queue_name
        data = dequeue queue_name
        yield data unless data.nil?
      end
    end
  end
end
