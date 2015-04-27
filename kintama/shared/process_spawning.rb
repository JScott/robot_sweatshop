$for_a_moment = 0.1
$for_a_while = 0.5
$for_io_calls = 1
$for_everything = 2

Kintama.on_start do
  puts `#{__dir__}/../../bin/sweatshop start --testing`
  FileUtils.cp "#{__dir__}/../data/test_job.yaml", File.expand_path(configatron.job_directory)
  FileUtils.cp "#{__dir__}/../data/git_job.yaml", File.expand_path(configatron.job_directory)
  sleep $for_everything
end

Kintama.on_finish do
  puts `#{__dir__}/../../bin/sweatshop stop`
end
