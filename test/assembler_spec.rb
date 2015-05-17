require 'bundler/setup'
require 'kintama'
require 'ezmq'
require 'oj'
require 'timeout'
require 'robot_sweatshop/config'
require_relative 'shared/setup'
require_relative 'shared/helpers'
$stdout.sync = true

Kintama.on_start do
  Setup::clear_conveyor
  @pids = []
  @pids.push Setup::process('assembler')
  @pids.push Setup::process('conveyor')
  @pids.push Setup::process('payload-parser')
  @puller = Setup::stub 'Puller', port: configatron.worker_port
  Setup::test_jobs
end

Kintama.on_finish do
  @pids.each { |pid| Process.kill 'TERM', pid }
end

describe 'the Job Assembler' do
  include InputHelper

  setup do
    client_settings = {
      port: configatron.conveyor_port,
      encode: -> message { Oj.dump message },
      decode: -> message { Oj.load message }
    }
    @client = Setup::client port: configatron.conveyor_port
    # clear_stub_output
  end

  teardown do
    @client.socket.close
    @client.context.terminate
  end

  %w(Git JSON MinimalJob).each do |request|
    given "#{request} requests on the Conveyor" do
      setup do
        @client.request(job_enqueue(request),{})
        sleep $a_moment
        @worker_data = eval File.read(stub_output)
      end

      should 'push the parsed payload to a Worker' do
        assert_kind_of Hash, @worker_data[:context]
        assert_kind_of Array, @worker_data[:commands]
        assert_kind_of String, @worker_data[:job_name]
      end

      should 'store everything in the context as strings' do
        @worker_data[:context].each do |key, value|
          assert_kind_of String, key
          assert_kind_of String, value
        end
      end

      should 'build the context with a parsed payload' do
        if request == 'Git'
          assert_equal 'develop', @worker_data[:context]['branch']
        else
          p @worker_data
          assert_equal 'value', @worker_data[:context]['test1']
        end
      end

      should 'grab commands from the job config' do
        assert_match /echo/, @worker_data[:commands].first
      end
    end
  end

  %w(IgnoredBranch UnknownJob EmptyJob NonJSON).each do |request|
    given "#{request} requests on the Conveyor" do
      setup do
        @client.request(job_enqueue(request),{})
        sleep $a_moment
      end

      should 'push nothing to Workers' do
        assert_equal false, File.exist?(stub_output)
      end
    end
  end
end
