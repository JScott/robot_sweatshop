require 'ezmq'
require 'oj'
require 'robot_sweatshop/config'

module ExtendedEZMQ
  refine EZMQ::Socket do
    def serialize_with_json!(except_encode_because_of_ezmq_bug: false)
      # EZMQ issue #4
      self.encode = -> message { Oj.dump message } unless except_encode_because_of_ezmq_bug
      self.decode = -> message { Oj.load message }
    end

    def close
      self.socket.close
      self.context.terminate
    end
  end
end
