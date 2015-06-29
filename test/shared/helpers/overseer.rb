require 'bundler/setup'
require 'robot_sweatshop/config'

module OverseerHelper
  def overseer_url
    "http://localhost:#{configatron.overseer_port}/"
  end

  def overseer_log_url(process)
    "http://localhost:#{configatron.overseer_port}/log?for=#{process}"
  end
end
