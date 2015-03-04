require 'yaml'

def default_config
  File.read "#{__dir__}/../../config.yaml"
end

def generate_default_config(in_directory: '~')
  config_path = File.expand_path "#{in_directory}/.robot_sweatshop.yaml"
  unless File.file?(config_path)
    File.write config_path, default_config
    notify :success, "Created new custom configuration at '#{config_path}'"
  else
    notify :failure, "Custom configuration already exists at '#{config_path}'"
  end
end
