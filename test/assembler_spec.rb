require 'bundler/setup'
require 'kintama'
require 'ezmq'
require 'oj'
require 'timeout'
require 'robot_sweatshop/config'

describe 'the Job Assembler' do
  # include InputHelper

  setup do
    @client = EZMQ::Client.new port: configatron.conveyor_port
  end

  %w(Git JSON MinimalJob).each do |request|
    given "#{request} requests in \'payload\'" do
      setup do
        payload = example_job_request of_type: request
        @client.request "#{@payloads_queue} #{payload}"
        sleep $for_a_moment
      end

      should 'remove the request from \'payload\'' do
        response = @client.request @payloads_queue
        assert_equal '', response
      end

      should 'enqueue commands, context, and job name to \'jobs\'' do
        response = @client.request "mirror-#{@jobs_queue}"
        response = JSON.load response
        assert_kind_of Hash, response['context']
        assert_kind_of Array, response['commands']
        assert_kind_of String, response['job_name']
      end

      should 'store everything in the context as strings' do
        response = @client.request "mirror-#{@jobs_queue}"
        response = JSON.load response
        response['context'].each { |_key, value| assert_kind_of String, value }
      end

      unless request == 'EmptyPayload'
        should 'build the context with a parsed payload' do
          response = @client.request "mirror-#{@jobs_queue}"
          response = JSON.load response
          assert_kind_of Hash, response['context']
          if request == 'Git'
            assert_equal 'develop', response['context']['branch']
          else
            assert_equal 'value', response['context']['test1']
          end
        end
      end
    end
  end

  %w(IgnoredBranch UnknownJob EmptyJob NonJSON).each do |request|
    given "#{request} requests in \'payload\'" do
      setup do
        payload = example_job_request of_type: request
        @client.request "#{@payloads_queue} #{payload}"
        sleep $for_a_moment
      end

      should 'remove the request from \'payload\'' do
        response = @client.request @payloads_queue
        assert_equal '', response
      end

      should 'not queue anything to \'jobs\'' do
        response = @client.request @jobs_queue
        assert_equal '', response
      end
    end
  end
end
