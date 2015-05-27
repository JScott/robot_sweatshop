require 'robot_sweatshop/config'

module CLI
  module Job
    def self.default
      "---\n# branch_whitelist:\n# - master\n\ncommands:\n- echo \"Hello $WORLD!\"\n\nenvironment:\n  WORLD: Earth\n"
    end

    def self.path_for(job)
      "#{configatron.job_path}/#{job}.yaml"
    end

    # def self.list
    #   job_path = File.expand_path configatron.job_path
    #   puts Dir.glob("#{job_path}/*.yaml").map { |file| File.basename(file, '.yaml') }
    # end
  end
end
