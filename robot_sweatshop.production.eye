#!/usr/bin/env ruby
require 'configatron'
configatron.temp do
  configatron.eye.broadcaster_interval = ''
  configatron.eye.worker_id = ''
  Eye.load('./robot_sweatshop.eye')
end
