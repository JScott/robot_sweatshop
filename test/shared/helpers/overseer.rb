require 'bundler/setup'
require 'robot_sweatshop/config'

module OverseerHelper
  def overseer_url
    "http://localhost:#{configatron.overseer_port}/"
  end
end
