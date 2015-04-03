require 'yaml'
require 'fileutils'
require_relative '../config'

def default_config
  File.read "#{__dir__}/../../config.yaml"
end

def user_config_file
  '/etc/robot_sweatshop/config.yaml'
end

def remove_user_config
  FileUtils.rm_rf user_config_file
  notify :success, 'Removing current user config file'
end

def create_and_edit_user_config
  create_and_edit user_config_file, with_default: default_config
end
