require 'ezmq'
require 'oj'
require 'robot_sweatshop/config'

module ExtendedEZMQ
  refine EZMQ::Socket do
    def serialize_with_json!
      self.encode = -> message { Oj.dump message }
      self.decode = -> message { Oj.load message }
    end

    def close
      self.socket.close
      self.context.terminate
    end
  end
end
