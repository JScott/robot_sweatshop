require 'ezmq'

Before('@run_queue_handler') do
  unless $queue_handler_running
    script = File.expand_path "#{__dir__}/../../queue/handler.rb"
    $queue_handler = Thread.new { `#{script}` } 
    $client = EZMQ::Client.new
    $queue_handler_running = true
  end
end

at_exit do
  if $queue_handler_running
    Thread.kill $queue_handler
    $client.socket.close
    $client.context.terminate
  end
end
