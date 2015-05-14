require 'bundler/setup'
require 'kintama'
require 'ezmq'
require 'oj'
require 'timeout'
require 'http'
require 'robot_sweatshop/config'
require 'fileutils'
require_relative 'shared/setup'
require_relative 'shared/helpers'
$stdout.sync = true

Kintama.on_start do
  @pid = Setup::process 'input'
  sleep $a_moment
  @server_thread = Setup::stub_server
end

Kintama.on_finish do
  Process.kill 'TERM', @pid
  @server_thread.kill
end

given 'the HTTP Input' do
  include InputHelper

  %w(Bitbucket Github JSON Empty).each do |format|
    context "POSTing #{format} data" do
      setup do
        url = input_http_url for_job: 'test_job'
        Timeout.timeout($a_moment) { @response = HTTP.post url, body: example_raw_payload(of_format: format) }
        assert_equal 200, @response.code
      end

      should 'send to the conveyor' do
        assert_equal true, File.exists?('.test.txt')
      end

      should 'enqueue payload details, user agent, and job name' do
        request = eval File.read('.test.txt') # please don't hack me thx
        assert_equal 'enqueue', request[:method]
        assert_not_nil request[:data][:payload]
        assert_not_nil request[:data][:user_agent]
        assert_not_nil request[:data][:job_name]
      end
    end
  end
end
