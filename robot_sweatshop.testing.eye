#!/usr/bin/env ruby
Eye.load('lib/sweatshop/config.rb')

configatron.temp do
  configatron.eye.broadcaster_interval = 0.0
  configatron.eye.worker_id = 'testingid'
  Eye.load('robot_sweatshop.eye')
end
