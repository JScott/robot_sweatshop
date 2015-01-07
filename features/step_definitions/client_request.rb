require 'ezmq'

When /^I request '(.*?)'$/ do |request|
  @response = @client.request request
end

Then /^I receive '(.*?)'$/ do |response|
  expect(@response).to eq response
end
