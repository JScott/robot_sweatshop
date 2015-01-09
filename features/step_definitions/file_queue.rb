require 'moneta'
require_relative '../../queue/lib/file-queue.rb'

$queue = FileQueue.new 'test-queue'

Given /^nothing is in the '(.*?)' queue$/ do |queue_name|
  queue = FileQueue.new queue_name
  queue.clear
  expect(queue.size).to eq 0
end

Given /^something is in the '(.*?)' queue$/ do |queue_name|
  queue = FileQueue.new queue_name
  unless queue.size > 0
    queue.push 'one'
    queue.push 'two'
  end
end
