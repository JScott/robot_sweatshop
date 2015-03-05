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
    @job_name = 'example'
    @raw_payload_queue = 'raw-payload'
    clear_all_queues
  end
  
  %w(Bitbucket).each do |git_host|
    context "POST data from #{git_host}" do
      setup do
        url = input_http_url for_job: @job_name, in_format: git_host
        HTTP.post url, body: load_payload(git_host)
      end

      should 'enqueue to \'raw-payload\'' do
        Timeout.timeout($for_a_moment) do
          @subscriber.listen do |message, topic|
            break if message == @raw_payload_queue
          end
        end
      end

      should 'enqueue payload details' do
        response = @client.request "mirror-#{@raw_payload_queue}"
        data = JSON.parse response
        %w(payload format job_name).each do |type|
          assert_kind_of String, data[type]
        end
      end
    end
  end
end
