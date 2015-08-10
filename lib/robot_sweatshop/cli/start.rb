require 'yaml'
require 'terminal-announce'
require 'robot_sweatshop/config'
require 'erubis'

module CLI
  # Methods for starting Robot Sweatshop
  module Start
    def self.sweatshop
      Announce.info `eye stop robot_sweatshop`
      load_eye_config
      Announce.info `eye start robot_sweatshop`
    end

    def self.load_eye_config
      Config.compile_to_file
      output = `eye load #{generate_eye_config}`
      fail output if $?.exitstatus != 0
      Announce.success "Robot Sweatshop workers loaded"
      Announce.info 'Run \'eye --help\' for more info on debugging'
    end

    def self.generate_eye_config
      template = File.read "#{__dir__}/robot_sweatshop.eye.erb"
      eruby = Erubis::Eruby.new template
      compiled_config = eruby.result worker_count: configatron.worker_count
      compiled_config_file = File.expand_path '~/.robot_sweatshop/robot_sweatshop.eye'
      File.open compiled_config_file, 'w' do |file|
        file.write compiled_config
        file.path
      end
    end
  end
end
