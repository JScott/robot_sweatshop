require 'erubis'

# Helper methods for the Overseer Sinatra server
module OverseerHelper
  def log_list
    %w(assembler conveyor input job-dictionary overseer payload-parser worker)
  end

  def frontpage
    context = { logs: log_list }
    p context
    template = File.read "#{__dir__}/templates/index.html.eruby"
    eruby = Erubis::Eruby.new template
    p eruby
    eruby.result context
  end
end
