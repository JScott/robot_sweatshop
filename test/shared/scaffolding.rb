require 'bundler/setup'
require 'fileutils'
require 'oj'
require 'robot_sweatshop/config'
require 'robot_sweatshop/connections'
require_relative 'stub'

module Setup
  def self.empty_conveyor
    db_file = "#{configatron.database_path}/conveyor.db"
    File.truncate db_file, 0 if File.exist? db_file
  end

  def self.populate_test_jobs
    test_jobs = Dir.glob "#{__dir__}/../data/*_job.yaml"
    test_jobs.each { |test_job| FileUtils.cp test_job, configatron.job_path }
  end
end

module TestProcess
  def self.start(name_list)
    pids = []
    name_list.each do |name|
      input_script = File.expand_path "#{__dir__}/../../bin/sweatshop-#{name}"
      input_script += ' testingid' if name == 'worker'
      pids.push spawn(input_script, out: '/dev/null', err: '/dev/null')
    end
    pids
  end

  def self.stop(pid_list)
    pid_list.each { |pid| Process.kill 'TERM', pid }
  end

  def self.stub(process_name)
    process = {
      conveyor: {type: 'Server', port: configatron.conveyor_port},
      worker:   {type: 'Puller', port: configatron.worker_port}
    }[process_name]
    Stub.new process[:type], on_port: process[:port]
  end
end
