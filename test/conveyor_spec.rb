require 'bundler/setup'
require 'kintama'
require 'ezmq'
require 'timeout'
require 'robot_sweatshop/config'
require 'robot_sweatshop/connections'
require_relative 'shared/scaffolding'
$stdout.sync = true

Kintama.on_start do
  @pids = Processes.start %w(conveyor)
end

Kintama.on_finish do
  Processes.stop @pids
end

describe 'the Conveyor' do
  using ExtendedEZMQ

  setup do
    @client = EZMQ::Client.new port: configatron.conveyor_port
    @client.serialize_with_json!
    @item = {test: 'item'}
  end

  teardown do
    @client.close
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
