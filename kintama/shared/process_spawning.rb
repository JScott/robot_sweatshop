#fail 'Please run with sudo for the sake of process running' unless Process.euid == 0

$for_a_moment = 0.1
$for_a_while = 0.5
$for_io_calls = 1
$for_everything = 3

Kintama.on_start do
  puts "(Re)loading Robot Sweatshop processes..."
  #`sudo #{__dir__}/../../bin/sweatshop start --testing`
  #sleep 3
end

Kintama.on_finish do
  #`sudo #{__dir__}/../../bin/sweatshop stop`
end
