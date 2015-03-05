require 'fileutils'
require_relative 'common'

def empty_config
  File.read "#{__dir__}/../../config.yaml"
end

def user_config_file
  "#{__dir__}/../../config.user.yaml"
end

def create_and_edit_user_config
  create_and_edit user_config_file, with_default: empty_config
end

def remove_user_config
  notify :warning, 'Removing old user configuration'
  FileUtils.rm_rf user_config_file
end
