require 'fileutils'
require 'robot_sweatshop/config'

module CLI
  # Methods for configuring Robot Sweatshop
  module Config
    def self.default
      File.read "#{__dir__}/../../../config.defaults.yaml"
    end

    def self.path(for_user: false)
      if for_user
        '~/.robot_sweatshop/config.yaml'
      else
        '.robot_sweatshop/config.yaml'
      end
    end

    def self.expand_paths_in(config_hash)
      config_hash.each do |key, value|
        config_hash[key] = File.expand_path value if key.to_s.match(/_path/)
      end
    end

    def self.write(config_hash)
      config_home = File.expand_path('~/.robot_sweatshop')
      FileUtils.mkpath config_home
      File.write "#{config_home}/compiled_config.yaml", config_hash.to_yaml
    end

    def self.compile_to_file
      config = expand_paths_in configatron.to_h
      config[:working_path] = Dir.pwd
      write config
    end
  end
end
