$for_a_moment = 0.1
$for_a_while = 0.5
$for_io_calls = 1
$for_everything = 3

Kintama.on_start do
  puts `#{__dir__}/../../bin/sweatshop start --testing`
  sleep $for_everything
end

Kintama.on_finish do
  puts `sudo #{__dir__}/../../bin/sweatshop stop`
end
