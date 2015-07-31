require 'ezmq'
require 'oj'
require 'robot_sweatshop/config'

# Add some common methods to ZMQ sockets that get repeated everywhere
module ExtendedEZMQ
  refine EZMQ::Socket do
    def serialize_with_json!
      self.encode = -> message { Oj.dump message }
      self.decode = -> message { Oj.load message }
    end

    def close
      socket.close
      context.terminate
    end
  end
end

# A logger that publishes what it writes
module EZMQ
  class Logger
    using ExtendedEZMQ

    def initialize(process)
      @process = process
      @logger = EZMQ::Publisher.new :connect, port: configatron.reflector_port
      @logger.serialize_with_json!
      @user = `whoami`.chomp
      @host = `hostname`.chomp
    end

    def write(text)
      data = {
        text: text,
        process: @process,
        user: @user,
        host: @host
      }
      @logger.send data, topic: 'robot-sweatshop-logging'
      nil
    end
  end
end
