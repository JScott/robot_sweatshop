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

  def self.stub(type, port:)
    FileUtils.rm '.test.txt' if File.exist? '.test.txt'
    Thread.new do
      puller = EZMQ.const_get(type).new socket_settings(port)
      p puller
      puller.listen { |message| write message }
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
end
