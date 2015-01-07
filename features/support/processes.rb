require 'ezmq'

Before('@run_queue_handler') do
  unless @queue_handler_running
    script = File.expand_path "#{__dir__}/../../queue/handler.rb &"
    @queue_handler = Thread.new { `#{script}` } 
    @queue_handler_running = true
    @client = EZMQ::Client.new
  end
end

After('@run_queue_handler') do
  Thread.kill @queue_handler
  @queue_handler_running = false
end
