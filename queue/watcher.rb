#!/usr/bin/env ruby
require_relative 'lib/file-queue'

@queue = FileQueue.new ARGV[0]

loop do
  system 'clear'
  puts "Queue: #{ARGV[0]}"
  puts "Size: #{@queue.size}", "#{'|'*@queue.size}"
  puts @queue.store[ARGV[0]].inspect
  sleep 1
end
