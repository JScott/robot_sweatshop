require_relative '../../payload/lib/bitbucket'
require_relative '../../queue/lib/file-queue'
require 'yaml'
require 'ezmq'
require 'json'

When /^(.*?) payload data is put in the '(.*?)' queue$/ do |payload_type, queue_name|
  payload_strings = YAML.load_file "#{__dir__}/../data/payloads.yaml"
  client = EZMQ::Client.new port: 5556
  payload_data = {
    payload: payload_strings[payload_type],
    format: payload_type
  }
  client.request "#{queue_name} #{JSON.generate payload_data}"
end

When /^I wait a second$/ do
  sleep 1
end
