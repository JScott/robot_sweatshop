#!/usr/bin/env ruby
require 'nats/client'
require 'lib/config'

["TERM", "INT"].each { |sig| trap(sig) { NATS.stop } }

NATS.on_error { |err| puts "Server Error: #{err}"; exit! }

subject = 'sweatshop.job'
queue_group = 'sweatshop.workers'
worker_id = 'uuid of some sort'

NATS.start do
  puts "Listening on [#{subject}], queue group [#{queue_group}]"
  NATS.subscribe(subject, :queue => queue_group) do |json|
    puts "Received '#{json}'"
    save_config_from json
    run_scripts
  end
end
