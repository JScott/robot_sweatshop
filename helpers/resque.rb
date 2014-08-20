require_relative 'scripts'
require_relative 'payload'
require 'resque'

class RunScriptsJob
  def perform(job_name, job_data, payload)
    set_environment_variables payload
    job_data['environment'].each { |key, value| ENV[key] = value }
    run_scripts job_name, job_data['scripts'], payload
  end
end

def enqueue_scripts(*params)
  Resque.enqueue RunScriptsJob, *params  
end

def configure_resque
  Resque.configure do |config|
    config.redis = 'localhost:6379'
  end
end
