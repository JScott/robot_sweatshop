require 'ezmq'

Given /^nothing is in the queue$/ do
end

When /^I request '(.*?)'$/ do |request|
  @response = @client.request request
end

Then /^I receive '(.*?)'$/ do |response|
  expect(@response).to eq response
end

Then /^I receive nil$/ do
  expect(@response).to be_nil
end
