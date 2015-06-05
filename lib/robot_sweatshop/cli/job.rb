require 'robot_sweatshop/config'

module CLI
  # Methods for creating and editing jobs
  module Job
    def self.default
      "---
      # branch_whitelist:
      # - master

      commands:
      - echo \"Hello $WORLD!\"

      environment:
        WORLD: Earth
      "
    end

    def self.path_for(job)
      "#{configatron.job_path}/#{job}.yaml"
    end

    def self.list
      job_path = File.expand_path configatron.job_path
      puts Dir.glob("#{job_path}/*.yaml").map { |file| File.basename(file, '.yaml') }
    end
  end
end
