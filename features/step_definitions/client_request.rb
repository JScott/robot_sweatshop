require 'ezmq'

Given /^I am a connected client$/ do
  @client = EZMQ::Client.new port: 5556
end

When /^I request '(.*?)'$/ do |request|
  @response = @client.request request
end

Then /^I receive '(.*?)'$/ do |response|
  expect(@response).to eq response
end
