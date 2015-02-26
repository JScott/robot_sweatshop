require 'ezmq'

module QueueHelper
  @@client = EZMQ::Client.new port: 5556
  
  def self.dequeue(queue_name = 'default')
    @@client.request queue_name
  end

  def self.enqueue(object = {}, to: 'default')
    @@client.request "#{to} #{JSON.generate object}"
  end

  def self.wait_for_queue(queue_name = 'default')
    puts "Waiting for messages on #{queue_name}"
    subscriber = EZMQ::Subscriber.new port: 5557, topic: 'busy-queues'
    subscriber.listen do |message|
      if message == queue_name
        data = self.dequeue queue_name
        yield data unless data.empty?
      end
    end
  end
end