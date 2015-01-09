require 'ezmq'

Given /^the queue handler is running$/ do
  script = File.expand_path "#{__dir__}/../../queue/handler.rb"
  unless $subprocesses.key? :queue_handler
    $subprocesses[:queue_handler] = Process.spawn script
  end
end

Given /^I am a connected client$/ do
  @client = EZMQ::Client.new
end

When /^I request '(.*?)'$/ do |request|
  @response = @client.request request
end

Then /^I receive '(.*?)'$/ do |response|
  expect(@response).to eq response
end
