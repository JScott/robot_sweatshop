$for_a_moment = 0.1
$for_a_while = 0.5
$for_io_calls = 1
$for_everything = 3

Kintama.on_start do
  puts `#{__dir__}/../../bin/sweatshop start --testing`
  FileUtils.cp "#{__dir__}/../data/test_job.yaml", configatron.job_directory
  sleep $for_everything
end

Kintama.on_finish do
  puts `#{__dir__}/../../bin/sweatshop stop`
  FileUtils.rm "#{configatron.job_directory}/test_job.yaml"
end
