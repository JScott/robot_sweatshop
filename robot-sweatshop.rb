#!/usr/bin/env ruby

if ARGV[0] == 'init'
  config = File.expand_path "#{__dir__}/robot-sweatshop.pill"
  exec "sudo bluepill load #{config}"
else
  exec "sudo bluepill robot-sweatshop #{ARGV[0]}"
end
