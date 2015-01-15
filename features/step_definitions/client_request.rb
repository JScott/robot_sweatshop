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

Then /^requesting '(.*?)' returns '(.*?)'$/ do |request, response|
  actual_response = @client.request request
  expect(actual_response).to eq response
end

Then /^requesting '(.*?)' returns something$/ do |request|
  actual_response = @client.request request
  expect(actual_response).to_not eq ''
end
