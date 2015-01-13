require 'yaml'
require 'rspec/mocks'
require_relative '../../payload/lib/bitbucket'
require_relative '../../queue/lib/file-queue'

Given /^a (.*?) payload is put in the '(.*?)' queue$/ do |payload_type, queue_name|
  payload_strings = YAML.load "#{__dir__}/../data/payloads.yaml"
  queue = FileQueue.new queue_name
  expect {
    queue.push payload_strings[payload_type]
  }.to change { queue.size }.by 1
end

Then /^the payload is parsed$/ do
  expect_any_instance_of(Payload).to receive :to_hash
end

Then /^the payload is parsed to nil$/ do
  expect_any_instance_of(Payload).to receive(:to_hash).and_return nil
end

Then /^the payload is pushed to the '(.*?)' queue$/ do |queue_name|
  expect_any_instance_of(FileQueue).to receive(:push).with /#{queue_name}/
end

Then /^nothing is pushed to the '(.*?)' queue$/ do |queue_name|
  expect_any_instance_of(FileQueue).to_not receive(:push)
end
