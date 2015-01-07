require 'moneta'

Given /^nothing is in the '(.*?)' queue$/ do |queue|
  $queues.delete queue
end

Given /^something is in the '(.*?)' queue$/ do |queue|
  $queues[queue] = ['one', 'two']
end
