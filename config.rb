require 'configatron'
require 'yaml'

configurations = [
  "#{__dir__}/config.yaml",
  "/etc/robot_sweatshop/config.yaml",
  "~/.robot_sweatshop/config.yaml",
  ".robot_sweatshop/config.yaml",
]
configurations.each do |config_path|
  config_path = File.expand_path config_path
  if File.file? config_path
    hash = YAML.load_file config_path
    configatron.configure_from_hash hash
  end
end
