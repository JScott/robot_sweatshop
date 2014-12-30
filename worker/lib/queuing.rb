require_relative 'script_running'
require 'sidekiq'

class RunScriptsWorker
  include Sidekiq::Worker

  def perform(job, with_environment_vars: {})
    with_environment_vars.each { |key, value| ENV[key.to_s] = value.to_s }
    start_job job, with_logger: logger
  end
end
