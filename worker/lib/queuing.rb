require_relative 'script_running'
require 'sidekiq'

class RunScriptsWorker
  include Sidekiq::Worker

  def perform(job, environment_vars)
    environment_vars.merge! job['environment'] unless job['environment'].nil?
    environment_vars.each { |key, value| ENV[key.to_s] = value.to_s }
    from_workspace(named: job['name']) do
      job['scripts'].each { |command| run command, log: logger }
    end
  end
end
