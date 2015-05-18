require 'bundler/setup'
require 'ezmq'
require 'fileutils'
require 'oj'
require 'robot_sweatshop/config'

module Setup
  def self.process(name)
    input_script = File.expand_path "#{__dir__}/../../bin/sweatshop-#{name}"
    spawn input_script, out: '/dev/null', err: '/dev/null'
  end

  def self.clear_conveyor
    db_file = "#{configatron.database_path}/conveyor.db"
    File.truncate db_file, 0 if File.exist? db_file
  end

  def self.client(port:)
    client_settings = {
      port: port, # TODO: socket_settings??
      encode: -> message { Oj.dump message },
      decode: -> message { Oj.load message }
    }
    EZMQ::Client.new client_settings
  end

  def self.stub(type, port:)
    FileUtils.rm '.test.txt' if File.exist? '.test.txt'
    Thread.new do
      listener = EZMQ.const_get(type).new socket_settings(port)
      listener.listen { |message| write message }
    end
  end

  def self.write(message)
    file = File.new '.test.txt', 'w'
    file.write message
    file.close
  end

  def self.socket_settings(port)
    {
      port: port,
      encode: -> message { Oj.dump message },
      decode: -> message { Oj.load message }
    }
  end

  def self.test_jobs
    test_jobs = Dir.glob "#{__dir__}/../data/*_job.yaml"
    test_jobs.each { |test_job| FileUtils.cp test_job, configatron.job_path }
  end
end
