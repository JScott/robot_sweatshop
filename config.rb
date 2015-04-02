require 'configatron'
require 'yaml'

# TODO: namespace to avoid collisions?

configurations = [
  "#{__dir__}/config.yaml",
  "#{__dir__}/config.user.yaml",
  "/etc/robot_sweatshop/config.yaml"
]
configurations.each do |config_path|
  if File.file? config_path
    hash = YAML.load_file config_path
    configatron.configure_from_hash hash
  end
end
