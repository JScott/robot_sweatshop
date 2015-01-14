require 'ezmq'
require 'timeout'

Given /^I subscribe to the '(.*?)' queue$/ do |queue|
  @subscriber = EZMQ::Subscriber.new port: 5557, topic: 'busy-queues'
  @subscriber.subscribe queue
end

Then /^I hear '(.*?)' on '(.*?)'$/ do |expected_message, topic|
  response = Timeout.timeout(1) do
    @subscriber.listen do |message|
      topic, message = message.split ' '
      expect(topic).to eq topic
      expect(message).to eq expected_message
      break
    end
  end
end

Then /^I hear nothing$/ do
  expect {
    Timeout.timeout(1) do
      @subscriber.listen { |m| }
    end
  }.to raise_error Timeout::Error
end

#When /^'(.*?)' is empty after (\d+) seconds$/ do |queue_name, seconds|
#  sleep seconds.to_i
#  @subscriber.listen do |message|
#    busy_queue = message.gsub 'busy-queues ', ''
#    puts busy_queue
#    puts busy_queue == queue_name
#    raise "#{queue_name} still not empty" if busy_queue == queue_name
#    break
#  end
#end
