require 'ezmq'
using ExtendedEZMQ

class Stub
  def initialize(type, on_port:)
    @type = type
    @port = on_port
    clear_output
    @thread = Thread.new { start_listener type, on_port } unless running?
  end

  def running?
    not `lsof -i :#{@port}`.empty? # TODO: I'm so sorry
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

  def start_listener(type, port)
    listener = case type
    when 'Puller'
      EZMQ::Puller.new :connect, port: port
    when 'Subscriber'
      EZMQ::Subscriber.new port: port, topic: 'robot-sweatshop-logging'
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
