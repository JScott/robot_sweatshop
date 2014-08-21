require_relative 'scripts'
require_relative 'payload'
require 'sidekiq'

class RunScriptsWorker
  include Sidekiq::Worker

  def perform(job_name, job_data, payload)
    set_environment_variables payload
    job_data['environment'].each { |key, value| ENV[key] = value }
    run_scripts job_name, job_data['scripts'], payload
  end
end

def configure_queue
  Sidekiq.configure_client do |config|
    config.redis = { :namespace => 'mci', :size => 1 }
  end
  Sidekiq.configure_server do |config|
    config.redis = { :namespace => 'mci' }
  end
end

def enqueue_scripts(*params)
  RunScriptsWorker.perform_async *params  
end
