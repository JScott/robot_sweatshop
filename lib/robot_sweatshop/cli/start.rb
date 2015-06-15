require 'yaml'
require 'terminal-announce'
require 'robot_sweatshop/config'

module CLI
  # Methods for starting Robot Sweatshop
  module Start
    def self.expand_paths_in(config_hash)
      config_hash.each do |key, value|
        config_hash[key] = File.expand_path value if key.to_s.match(/_path/)
      end
    end

    def self.store_config_for_eye
      config = expand_paths_in configatron.to_h
      config[:working_path] = Dir.pwd
      File.write '/tmp/.robot_sweatshop-eye-config.yaml', config.to_yaml
    end

    def self.sweatshop(for_environment:)
      store_config_for_eye
      eye_config = File.expand_path "#{__dir__}/../../../robot_sweatshop.eye"
      output = `eye load #{eye_config}`
      fail output if $?.exitstatus != 0
      Announce.success "Robot Sweatshop loaded with a #{for_environment} configuration"
      Announce.info `eye restart robot_sweatshop`
      Announce.info 'Run \'eye --help\' for more info on debugging'
    end
  end
end
