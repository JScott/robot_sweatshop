require 'bundler/setup'
require 'simplecov'

task :test do
  SimpleCov.command_name 'Kintama Tests'
  SimpleCov.start do
    add_filter "/vendor/"
    add_filter "/test/"
  end
  require_relative 'test/run_all'
end
