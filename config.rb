require 'configatron'
require 'yaml'

yaml = YAML.load_file "#{__dir__}/config.yaml"
configatron.configure_from_hash yaml
