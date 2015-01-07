require 'ezmq'

Before('@run_queue_handler') do
  unless $queue_handler_running
    script = File.expand_path "#{__dir__}/../../queue/handler.rb"
    #$queue_handler = Thread.new { `#{script}` } 
    $client = EZMQ::Client.new
    $queue_handler_running = true
  end
end

After('@run_queue_handler') do
  #Thread.kill $queue_handler while $queue_handler.alive?
end

at_exit do
  $client.socket.close
  $client.context.terminate
end
