require 'yaml'
require 'fileutils'

def default_config
  File.read "#{__dir__}/../../config.yaml"
end

def generate_default_config(in_directory: '~')
  config_directory = File.expand_path "#{in_directory}"
  config_file = "#{config_directory}/config.yaml"
  unless File.file?(config_file)
    FileUtils.mkdir_p config_directory
    File.write config_file, default_config
    notify :success, "Created new custom configuration at '#{config_file}'"
  else
    notify :failure, "Custom configuration already exists at '#{config_file}'"
  end
end
