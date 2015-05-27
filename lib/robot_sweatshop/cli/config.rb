require 'robot_sweatshop/config'

module CLI
  module Config
    def self.default
      File.read "#{__dir__}/../../../config.defaults.yaml"
    end

    def self.path(scope)
      case scope
      when 'system'
        "/etc/robot_sweatshop/config.yaml"
      when 'user'
        "~/.robot_sweatshop/config.yaml"
      else
        ".robot_sweatshop/config.yaml"
      end
    end
  end
end
