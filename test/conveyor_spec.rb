require 'bundler/setup'
require 'kintama'
require 'ezmq'
require 'oj'
require 'timeout'
require 'robot_sweatshop/config'
require_relative 'shared/setup'
$stdout.sync = true

Kintama.on_start do
  @pid = Setup::process 'conveyor'
end

Kintama.on_finish do
  Process.kill 'TERM', @pid
end

describe 'the Conveyor' do
  setup do
    client_settings = {
      port: configatron.conveyor_port,
      encode: -> message { Oj.dump message },
      decode: -> message { Oj.load message }
    }
    @client = EZMQ::Client.new client_settings
    @item = {test: 'item'}
  end

  should 'enqueue and dequeue items' do
    id = Timeout.timeout($a_moment) do
      @client.request({method: 'enqueue', data: @item}, {})
      @client.request({method: 'dequeue'}, {})
    end
    assert_kind_of Fixnum, id
  end

  should 'lookup items by ID' do
    item = Timeout.timeout($a_moment) do
      @client.request({method: 'enqueue', data: @item}, {})
      id = @client.request({method: 'dequeue'}, {})
      @client.request({method: 'lookup', data: id}, {})
    end
    assert_equal @item, item
  end

  should 'return nothing when given invalid data' do
    response = Timeout.timeout($a_moment) do
      @client.request 'not json'
      @client.request({method: 'invalid'}, {})
      @client.request ''
      @client.request 'assurance that the server is still up'
    end
    assert_nil response
  end

  should 'finish items by ID to prevent requeueing' do
    response = Timeout.timeout($a_moment) do
      @client.request({method: 'enqueue', data: @item}, {})
      id = @client.request({method: 'dequeue'}, {})
      @client.request({method: 'finish', data: id}, {})
    end
    assert_not_equal '', response
  end
end
