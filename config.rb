require 'configatron'
require 'yaml'

configurations = ["#{__dir__}/config.yaml"]

user_defined_config = File.expand_path '~/.robot_sweatshop.yaml'
configurations.push user_defined_config if File.file? user_defined_config

configurations.each do |config_path|
  hash = YAML.load_file config_path
  configatron.configure_from_hash hash
end
