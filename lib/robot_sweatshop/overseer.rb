require 'erubis'

# Helper methods for the Overseer Sinatra server
module OverseerHelper
  def log_list
    %w(assembler conveyor input job-dictionary overseer payload-parser worker)
  end

  def frontpage
    context = { logs: log_list }
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
