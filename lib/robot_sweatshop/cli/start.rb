require 'yaml'
require 'terminal-announce'
require 'robot_sweatshop/config'
require 'erubis'

module CLI
  # Methods for starting Robot Sweatshop
  module Start
    def self.sweatshop(with_worker_count: 1)
      Config.compile_to_file
      eye_config = generate_eye_config with_worker_count
      output = `eye load #{eye_config}`
      fail output if $?.exitstatus != 0
      Announce.success "Robot Sweatshop loaded"
      Announce.info `eye restart robot_sweatshop`
      Announce.info 'Run \'eye --help\' for more info on debugging'
    end

    def self.generate_eye_config(worker_count)
      template = File.read "#{__dir__}/robot_sweatshop.eye.erb"
      eruby = Erubis::Eruby.new template
      compiled_config = eruby.result worker_count: worker_count
      compiled_config_file = File.expand_path '~/.robot_sweatshop/robot_sweatshop.eye'
      File.open compiled_config_file, 'w' do |file|
        file.write compiled_config
        file.path
      end
    end
  end
end
