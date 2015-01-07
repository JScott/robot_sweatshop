require 'moneta'

Given /^nothing is in the '(.*?)' queue$/ do |queue|
  @queues.delete queue
end
