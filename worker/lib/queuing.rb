require_relative 'script_running'
require 'sidekiq'

class RunScriptsWorker
  include Sidekiq::Worker

  def perform(job_name, scripts = [], with_environment_vars: {})
    with_environment_vars.each { |key, value| ENV[key.to_s] = value.to_s }
    start_job job_name, scripts, with_logger: logger
  end
end

def enqueue_job(job_name, scripts = [], with_environment_vars: {})
  #TODO: maybe remove this entirely since it just passes through
  RunScriptsWorker.perform_async job_name, scripts, with_environment_vars: with_environment_vars
end
