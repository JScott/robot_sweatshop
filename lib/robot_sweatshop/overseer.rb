require 'erubis'

# Helper methods for the Overseer Sinatra server
module OverseerHelper
  def log_list
    log_path = File.expand_path "#{configatron.logfile_path}"
    Dir.glob("#{log_path}/*.log").map { |path| File.basename path, '.log' }
  end

  def job_list
    job_path = File.expand_path "#{configatron.job_path}"
    Dir.glob("#{job_path}/*.yaml").map { |path| File.basename path, '.yaml' }
  end

  def frontpage
    context = {
      jobs: job_list,
      logs: log_list,
      api_url: configatron.api_url
    }
    template = File.read "#{__dir__}/templates/index.html.eruby"
    eruby = Erubis::Eruby.new template
    eruby.result context
  end

  def log_page_for(process)
    context = {
      process: process,
      raw_log: File.read("#{configatron.logfile_path}/#{process}.log")
    }
    template = File.read "#{__dir__}/templates/log.html.eruby"
    eruby = Erubis::Eruby.new template
    eruby.result context
  end
end
