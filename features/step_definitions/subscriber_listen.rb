require 'ezmq'
require 'timeout'

Given /^the queue broadcaster is running$/ do
  script = File.expand_path "#{__dir__}/../../queue/broadcaster.rb"
  unless $subprocesses.key? :queue_broadcaster
    $subprocesses[:queue_broadcaster] = Process.spawn script
  end
end

Given /^I subscribe to the '(.*?)' queue$/ do |queue|
  @subscriber = EZMQ::Subscriber.new
  @subscriber.subscribe queue
end

Then /^I hear the queue count$/ do
  response = Timeout.timeout(1) { @subscriber.listen }
  expect(response).to_not be_nil
  expect(response.to_i).to be > 0
end

Then /^I hear nothing$/ do
  expect {
    Timeout.timeout(1) { @subscriber.listen }
  }.to raise_error Timeout::Error
end
