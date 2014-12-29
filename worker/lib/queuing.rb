require_relative 'script_running'
require 'sidekiq'

class RunScriptsWorker
  include Sidekiq::Worker

  def perform(job_name, scripts, with_environment_vars: {})
    with_environment_vars.each { |key, value| ENV[key.to_s] = value.to_s }
    start_job job_name, scripts
  end
end

def configure_queue
  Sidekiq.configure_client do |config|
    config.redis = { :namespace => 'robot-sweatshop', :size => 1 }
  end
  Sidekiq.configure_server do |config|
    config.redis = { :namespace => 'robot-sweatshop' }
  end
end

def enqueue_scripts(*params)
  RunScriptsWorker.perform_async *params  
end
