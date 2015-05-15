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

  def self.stub_server(bound_to:)
    FileUtils.rm '.test.txt' if File.exist? '.test.txt'
    Thread.new do
      server_settings = {
        port: bound_to,
        encode: -> message { Oj.dump message },
        decode: -> message { Oj.load message }
      }
      server = EZMQ::Server.new server_settings
      server.listen do |message|
        file = File.new '.test.txt', 'w'
        file.write message
        file.close
      end
    end
  end
end
