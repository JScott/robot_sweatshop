require 'yaml'
require 'terminal-announce'
require 'robot_sweatshop/config'

module CLI
  # Methods for starting Robot Sweatshop
  module Start
    def self.sweatshop
      Config.compile_to_file
      eye_config = File.expand_path "#{__dir__}/../../../robot_sweatshop.eye"
      output = `eye load #{eye_config}`
      fail output if $?.exitstatus != 0
      Announce.success "Robot Sweatshop loaded"
      Announce.info `eye restart robot_sweatshop`
      Announce.info 'Run \'eye --help\' for more info on debugging'
    end
  end
end
