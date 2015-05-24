require 'bundler/setup'
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
  @pids = Processes.start %w(input)
  sleep $a_while
  @conveyor_thread = Setup.stub 'Server', port: configatron.conveyor_port
end

Kintama.on_finish do
  Processes.stop @pids
  @conveyor_thread.kill
end

given 'the HTTP Input' do
  include InputHelper
  include OutputHelper

  %w(Bitbucket Github JSON Empty).each do |format|
    context "POSTing #{format} data" do
      setup do
        url = input_url for_job: 'test_job'
        Timeout.timeout($a_while) { @response = HTTP.post url, body: example_raw_payload(format) }
        assert_equal 200, @response.code
      end

      should 'send to the conveyor' do
        assert_equal true, File.exist?(stub_output)
      end

      should 'enqueue payload details, user agent, and job name' do
        request = eval File.read(stub_output) # please don't hack me thx
        assert_equal 'enqueue', request[:method]
        assert_not_nil request[:data][:payload]
        assert_not_nil request[:data][:user_agent]
        assert_not_nil request[:data][:job_name]
      end
    end
  end
end
