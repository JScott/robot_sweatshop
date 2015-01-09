require 'ezmq'
require 'timeout'

Given /^I subscribe to the '(.*?)' queue$/ do |queue|
  @subscriber = EZMQ::Subscriber.new port: 5557, topic: ''
  @subscriber.subscribe queue
end

Then /^I hear '(.*?)'$/ do |expected_message|
  response = Timeout.timeout(1) do
    @subscriber.listen do |message|
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
