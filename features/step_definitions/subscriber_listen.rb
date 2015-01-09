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
