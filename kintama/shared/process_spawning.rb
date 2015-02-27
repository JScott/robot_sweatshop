fail 'Please run with sudo for the sake of process running' unless Process.euid == 0

$for_a_moment = 0.5
$for_a_while = 1.0

def spawn(lib_path)
  puts "Starting #{lib_path}..."
  null_io = File.open File::NULL, 'w'
  @pids << Process.spawn("#{__dir__}/../../lib/#{lib_path}", out: null_io, err: null_io)
end

Kintama.on_start do
  @pids = []
  spawn 'input/http.rb' # Make sure the Sinatra port is available!
  spawn 'queue/handler.rb'
  spawn 'queue/broadcaster.rb'
  spawn 'payload/parser.rb'
  spawn 'job/assembler.rb'
  # spawn 'job/worker.rb testingid'
  sleep 2
end

Kintama.on_finish do
  sleep $for_a_while
  @pids.each do |pid|
    Process.kill :TERM, pid
    Process.wait pid
  end
end
