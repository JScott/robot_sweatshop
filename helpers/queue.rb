require_relative 'scripts'
require 'sidekiq'

class RunScriptsWorker
  include Sidekiq::Worker

  def perform(job_name, environment_vars, scripts)
    environment_vars.each { |key, value| ENV[key] = value }
    run_scripts job_name, scripts, logger
  end
end

def configure_queue
  Sidekiq.logger.formatter = proc do |severity, datetime, progname, msg|
    "[#{datetime}] #{severity} - #{msg}"
  end
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
