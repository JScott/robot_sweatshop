require 'configatron'
require 'yaml'
require 'terminal-announce'

configatron.reset!

configurations = [
  "#{__dir__}/../../config.defaults.yaml",
  '/etc/robot_sweatshop/config.yaml',
  '~/.robot_sweatshop/config.yaml',
  '.robot_sweatshop/config.yaml'
]

configurations.each do |config_path|
  begin
    config_path = File.expand_path config_path
    if File.file? config_path
      hash = YAML.load_file config_path
      configatron.configure_from_hash hash
    end
  rescue ArgumentError => error
    Announce.info "Couldn't load '#{config_path}': #{error.message}"
  end
end

require 'robot_sweatshop/create-config-directories'
