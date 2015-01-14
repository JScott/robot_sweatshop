require_relative '../../payload/lib/bitbucket'
require_relative '../../queue/lib/file-queue'
require 'yaml'

Then /^I expect payload parsing to happen$/ do
  expect_any_instance_of(Payload).to receive :to_hash
end

Then /^someting is pushed to the '(.*?)' queue$/ do |queue_name|
  expect_any_instance_of(FileQueue).to receive(:push)
  expect_any_instance_of(FileQueue).to receive(:push).with /#{queue_name}/
end

Then /^nothing is pushed to the '(.*?)' queue$/ do |queue_name|
  expect_any_instance_of(FileQueue).to receive(:push)
  expect_any_instance_of(FileQueue).to_not receive(:push)
end

When /^a (.*?) payload is put in the '(.*?)' queue$/ do |payload_type, queue_name|
  payload_strings = YAML.load_file "#{__dir__}/../data/payloads.yaml"
  queue = FileQueue.new queue_name
  #expect {
    queue.push payload_strings[payload_type]
  #}.to change { queue.size }.by 1
end

