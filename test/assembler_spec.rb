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
  @pids = []
  @pids.push Setup::process('assembler')
  @pids.push Setup::process('conveyor')
  @puller_thread = Setup::stub 'Puller', port: configatron.worker_port
end

Kintama.on_finish do
  @pids.each { |pid| Process.kill 'TERM', pid }
  @puller_thread.kill
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
  end

  %w(Git JSON MinimalJob).each do |request|
    given "#{request} requests on the conveyor" do
      setup do
        @client.request(job_enqueue(request),{})
        sleep $a_moment
      end

      should 'push the parsed payload to a Worker' do
        # check results from stub_pull
        assert_kind_of Hash, response['context']
        assert_kind_of Array, response['commands']
        assert_kind_of String, response['job_name']
      end

      should 'store everything in the context as strings' do
        # check results from stub_pull
        response['context'].each { |_key, value| assert_kind_of String, value }
      end

      should 'build the context with a parsed payload' do
        # check results from stub_pull
        if request == 'Git'
          assert_equal 'develop', response['context']['branch']
        else
          assert_equal 'value', response['context']['test1']
        end
      end
    end
  end

  %w(IgnoredBranch UnknownJob EmptyJob NonJSON).each do |request|
    given "#{request} requests in \'payload\'" do
      setup do
        @client.request(job_enqueue(request),{})
      end

      should 'push nothing to Workers' do
        # chck results from stub_pull
      end
    end
  end
end
