require_relative '../config'

def default_config
  File.read "#{__dir__}/../../../config.defaults.yaml"
end

def get_config_path(for_scope: 'local')
  case for_scope
  when 'system'
    "/etc/robot_sweatshop/config.yaml"
  when 'user'
    "~/robot_sweatshop/config.yaml"
  else
    ".robot_sweatshop/config.yaml"
  end
end
