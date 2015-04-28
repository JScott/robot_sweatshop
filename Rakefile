require 'bundler/setup'
require 'simplecov'

task :test do
  SimpleCov.command_name 'Kintama Tests'
  SimpleCov.start do
    add_filter "/vendor/"
    add_filter "/kintama/"
  end
  require_relative 'kintama/run_all'
end
