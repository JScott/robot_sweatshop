require 'bundler/setup'
require 'robot_sweatshop/config'

module OverseerHelper
  def overseer_url(path = '')
    "http://localhost:#{configatron.overseer_port}/#{path}"
  end
end
