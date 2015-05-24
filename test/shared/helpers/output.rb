require 'bundler/setup'
require 'fileutils'
require 'robot_sweatshop/payload'
require 'robot_sweatshop/config'

module OutputHelper
  def stub_output
    '.test.txt'
  end

  def worker_output
    "#{configatron.workspace_path}/test_job-testingid/test.txt"
  end

  def stub_output_empty?
    (not File.exist? stub_output) || File.read(stub_output).empty?
  end

  def clear_stub_output
    FileUtils.touch '.test.txt'
    File.truncate '.test.txt', 0
  end

  def clear_worker_output
    FileUtils.rm_rf worker_output
  end
end
