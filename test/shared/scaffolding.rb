require 'bundler/setup'
require 'ezmq'
require 'fileutils'
require 'oj'
require 'robot_sweatshop/config'
require 'robot_sweatshop/connections'
using ExtendedEZMQ

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

  class Stub
    def initialize(type, on_port:)
      @type = type
      @port = on_port
      clear_output
      @thread = Thread.new { create_listener type, on_port } unless running?
    end

    def running?
      not `lsof -i :#{@port}`.empty?
    end

    def output_file
      ".test.#{@type}"
    end

    def clear_output
      FileUtils.rm output_file if File.exist? output_file
    end

    def output_empty?
      (not File.exist? output_file) || File.read(output_file).empty?
    end

    def create_listener(type, port)
      listener = case type
      when 'Puller'
        EZMQ::Puller.new :connect, port: port
      else
        EZMQ.const_get(type).new port: port
      end
      listener.serialize_with_json!
      listener.listen { |message| write message }
    end

    def write(message)
      file = File.new output_file, 'w'
      file.write message
      file.close
    end
  end
end
