require 'moneta'
require_relative '../../queue/lib/file-queue.rb'

Given /^nothing is in the '(.*?)' queue$/ do |queue|
  queue = FileQueue.new queue
  #queue.delete queue
  expect(queue.size).to eq 0
end

Given /^something is in the '(.*?)' queue$/ do |queue|
  queue = FileQueue.new queue
  unless queue.size > 0
    queue.push 'one'
    queue.push 'two'
  end
end
