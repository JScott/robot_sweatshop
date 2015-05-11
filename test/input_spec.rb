require 'bundler/setup'
require 'kintama'
require 'ezmq'
require 'oj'
require 'timeout'
require 'http'
require 'robot_sweatshop/config'
require_relative 'shared/helpers'

Kintama.on_start do
  input_script = File.expand_path "#{__dir__}/../bin/sweatshop-input"
  @pid = spawn input_script, out: '/dev/null', err: '/dev/null'
  sleep 1

  @server_thread = Thread.new do
    server_settings = {
      port: configatron.conveyor_port,
      encode: -> message { Oj.dump message },
      decode: -> message { Oj.load message }
    }
    server = EZMQ::Server.new server_settings
    server.listen { |message| message }
  end
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
        Timeout.timeout(0.5) { @response = HTTP.post url, body: example_raw_payload(of_format: format) }
        assert_equal 200, @response.code
        @data_sent = Oj.load @response.body.to_s
      end

      should 'send to the conveyor' do
      end

      should 'enqueue payload details and format' do
      end

      # should 'enqueue to \'payload\'' do
      #   Timeout.timeout(@wait) do
      #     @subscriber.listen do |message, topic|
      #       break if message == @payload_queue
      #     end
      #   end
      # end

      # should 'enqueue payload details and format' do
      #   response = @client.request "mirror-#{@payload_queue}"
      #   data = Oj.parse response
      #   assert_kind_of String, data['payload']
      #   assert_kind_of String, data['user_agent']
      # end

      # should 'enqueue job name' do
      #   response = @client.request "mirror-#{@payload_queue}"
      #   data = Oj.parse response
      #   assert_kind_of String, data['job_name']
      # end
    end
  end
end
