require 'terminal-announce'
require 'rake'

task :test do
  require_relative 'test/all'
end

task :build do
  Announce.info 'Building and installing local gem...'
  puts `rm -rf robot_sweatshop-*.gem`
  puts `gem build robot_sweatshop.gemspec --force`
  puts `gem install robot_sweatshop-*.gem`
end
