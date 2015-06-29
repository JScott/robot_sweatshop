require 'erubis'

# Helper methods for the Overseer Sinatra server
module OverseerHelper
  def log_list
    %w(assembler conveyor input job-dictionary payload-parser worker)
  end

  def job_list
    log_path = File.expand_path "#{configatron.job_path}"
    p log_path, Dir.glob("#{log_path}/*.yaml")
    Dir.glob("#{log_path}/*.yaml").map { |path| File.basename path, '.yaml' }
  end

  def frontpage
    context = {
      jobs: job_list,
      logs: log_list
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
