require 'bundler/setup'
require 'kintama'
require 'ezmq'
require 'oj'
require 'robot_sweatshop/config'
# require_relative 'shared/process_spawning'
# require_relative 'shared/helpers'

Kintama.on_start do
  # raise "Please stop Robot Sweatshop before running tests" unless `lsof -i :#{configatron.conveyor_belt_port}`.empty?
  # conveyor_belt_script = File.expand_path "#{__dir__}/../bin/sweatshop-conveyor-belt"
  # pid = spawn conveyor_belt_script#, out: '/dev/null', err: '/dev/null'
  # Process.detach pid
  # sleep 1
end

describe 'the Conveyor Belt' do
  setup do
    client_settings = {
      port: configatron.conveyor_belt_port,
      encode: -> message { Oj.dump message },
      decode: -> message { Oj.load message }
    }
    @client = EZMQ::Client.new client_settings
    @item = 'test_item'
    @wait = 1
  end

  should 'enqueue and dequeue items' do
    id = Timeout.timeout(@wait) do
      @client.request({method: 'enqueue', data: @item}, {})
      @client.request({method: 'dequeue'}, {})
    end
    assert_kind_of Fixnum, id
  end

  should 'lookup items by ID' do
    item = Timeout.timeout(@wait) do
      @client.request({method: 'enqueue', data: @item}, {})
      id = @client.request({method: 'dequeue'}, {})
      @client.request({method: 'lookup', data: id}, {})
    end
    assert_equal @item, item
  end

  should 'return nothing when given invalid data' do
    response = Timeout.timeout(@wait) do
      @client.request 'not json'
      @client.request({method: 'invalid'}, {})
      @client.request ''
      @client.request 'assurance that the server is still up'
    end
    assert_nil response
  end
end
