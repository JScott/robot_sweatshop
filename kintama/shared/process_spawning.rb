fail 'Please run with sudo for the sake of process running' unless Process.euid == 0

$for_a_moment = 0.1
$for_a_while = 0.5
$for_io_calls = 1
$for_everything = 3

def spawn(lib_path)
  puts "Starting #{lib_path}..."
  null_io = File.open File::NULL, 'w'
  @pids << Process.spawn("#{__dir__}/../../lib/#{lib_path}", out: null_io, err: null_io)
end

Kintama.on_start do
  @pids = []
  puts "(Re)loading Robot Sweatshop processes..."
  `eye load #{__dir__}/../../robot_sweatshop.staging.eye`
  `eye restart robot_sweatshop`
  sleep 3
end

Kintama.on_finish do
  sleep $for_a_while
  @pids.each do |pid|
    Process.kill :TERM, pid
    Process.wait pid
  end
end
