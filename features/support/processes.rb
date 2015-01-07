require 'ezmq'

Before('@run_queue_handler') do
  unless $queue_handler_running
    script = File.expand_path "#{__dir__}/../../queue/handler.rb"
    $queue_handler = Thread.new { `#{script}` } 
    $client = EZMQ::Client.new
    $queue_handler_running = true
  end
end

Before('@run_queue_broadcaster') do
  unless $queue_broadcaster_running
    script = File.expand_path "#{__dir__}/../../queue/broadcaster.rb"
    $queue_handler = Thread.new { `#{script}` } 
    $subscriber = EZMQ::Subscriber.new
    $queue_broadcaster_running = true
  end
end

at_exit do
  if $queue_handler_running
    Thread.kill $queue_handler
    $client.socket.close
    $client.context.terminate
  end
  if $queue_broadcaster_running
    Thread.kill $queue_broadcaster
    $subscriber.socket.close
    $subscriber.context.terminate
  end
end
