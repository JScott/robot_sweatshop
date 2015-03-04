#!/usr/bin/env ruby
require 'configatron'
configatron.temp do
  configatron.eye.broadcaster_interval = 0.0
  configatron.eye.worker_id = 'testingid'
  Eye.load('./robot_sweatshop.eye')
end
