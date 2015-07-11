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
    job_path = File.expand_path configatron.job_path
    test_jobs.each { |job| FileUtils.cp job, job_path }
  end

  def self.populate_scripts
    test_scripts = Dir.glob "#{__dir__}/../data/*_script"
    scripts_path = File.expand_path configatron.scripts_path
    test_scripts.each { |script| FileUtils.cp script, scripts_path }
  end
end

module TestProcess
  def self.start(name_list)
    pids = []
    name_list.each do |name|
      command = File.expand_path "#{__dir__}/../../bin/sweatshop-#{name}"
      command += ' testingid' if name == 'worker'
      pids.push spawn(command, out: '/dev/null', err: '/dev/null')
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
