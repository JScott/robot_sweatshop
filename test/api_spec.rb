require 'kintama'
require 'ezmq'
require 'oj'
require 'timeout'
require 'http'
require 'robot_sweatshop/config'
require_relative 'shared/scaffolding'
require_relative 'shared/helpers'
$stdout.sync = true

Kintama.on_start do
  @pids = TestProcess.start %w(api)
  sleep $a_while
end

Kintama.on_finish do
  TestProcess.stop @pids
end

given 'the HTTP Input' do
  include InputHelper
  include OutputHelper

  %w(Bitbucket Github JSON Empty EmptyJSON).each do |format|
    context "POSTing #{format} data" do
      setup do
        @conveyor = TestProcess.stub :conveyor
        url = job_running_url for_job: 'test_job'
        Timeout.timeout($a_while) do
          @response = HTTP.post url, body: example_raw_payload(format)
        end
        assert_equal 200, @response.code
      end

      should 'send to the conveyor' do
        assert_equal true, File.exist?(@conveyor.output_file)
      end

      should 'enqueue payload details, user agent, and job name' do
        request = eval File.read(@conveyor.output_file) # please don't hack me thx
        assert_equal 'enqueue', request[:method]
        assert_not_nil request[:data][:payload]
        assert_not_nil request[:data][:user_agent]
        assert_not_nil request[:data][:job_name]
      end
    end
  end
end
