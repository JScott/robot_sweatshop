require 'kintama'
require 'ezmq'
require 'json'
require 'timeout'
require 'http'
require_relative 'shared/process_spawning'
require_relative 'shared/helpers'

given 'the HTTP Input' do
  include QueueHelper
  include InHelper

  setup do
    @subscriber = EZMQ::Subscriber.new port: 5557, topic: 'busy-queues'
    @client = EZMQ::Client.new port: 5556
    @job_name = 'test_job'
    @payload_queue = 'payload'
    clear_all_queues
  end
  
  %w(Bitbucket Github JSON).each do |format|
    context "POSTing #{format} data" do
      setup do
        url = input_http_url for_job: @job_name
        payload = example_raw_payload of_format: format
        HTTP.post url, body: payload
      end

      should 'enqueue to \'payload\'' do
        Timeout.timeout($for_a_moment) do
          @subscriber.listen do |message, topic|
            break if message == @payload_queue
          end
        end
      end

      should 'enqueue payload details' do
        response = @client.request "mirror-#{@payload_queue}"
        data = JSON.parse response
        %w(payload job_name).each do |type|
          assert_kind_of String, data[type]
        end
      end
    end
  end
end
