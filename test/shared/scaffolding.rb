require 'bundler/setup'
require 'ezmq'
require 'fileutils'
require 'oj'
require 'robot_sweatshop/config'
require 'robot_sweatshop/connections'
using ExtendedEZMQ

module Processes
  def self.start(name_list)
    pids = []
    name_list.each do |name|
      input_script = File.expand_path "#{__dir__}/../../bin/sweatshop-#{name}"
      pids.push spawn(input_script, out: '/dev/null', err: '/dev/null')
    end
    pids
  end

  def self.stop(pid_list)
    pid_list.each { |pid| Process.kill 'TERM', pid }
  end
end

module Setup
  def self.empty_conveyor
    db_file = "#{configatron.database_path}/conveyor.db"
    File.truncate db_file, 0 if File.exist? db_file
  end

  def self.stub(type, port:)
    FileUtils.rm '.test.txt' if File.exist? '.test.txt'
    Thread.new do
      listener = EZMQ.const_get(type).new port: port
      listener.serialize_with_json!
      listener.listen { |message| write message }
    end
  end

  def self.write(message)
    file = File.new '.test.txt', 'w'
    file.write message
    file.close
  end

  def self.populate_test_jobs
    test_jobs = Dir.glob "#{__dir__}/../data/*_job.yaml"
    test_jobs.each { |test_job| FileUtils.cp test_job, configatron.job_path }
  end
end
