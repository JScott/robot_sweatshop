#!/usr/bin/env ruby
require 'resque/cli'
args = [
  'work',
  '--config="./.resque"'
]
Resque::CLI.start(ARGV)
