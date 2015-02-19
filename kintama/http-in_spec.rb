require 'kintama'
require 'ezmq'
require 'timeout'
require 'http'
require_relative 'helpers'

given 'the HTTP Input' do
  include QueueHelper
  include InHelper

  setup do
    @subscriber = EZMQ::Subscriber.new port: 5557, topic: 'busy-queues'
    @job_name = 'example'
    @raw_payload_queue = 'raw-payload'
    clear_all_queues
  end
  
  ['Bitbucket'].each do |git_host|
    context "POST data from #{git_host}" do
      setup do
        url = "http://localhost/#{git_host}/payload-for/#{@job_name}"
        HTTP.post url, body: load_payload(git_host)
      end

      should 'publish to \'raw-payload\'' do
        Timeout.timeout($for_a_while) do
          @subscriber.listen do |message, topic|
            assert_equal @raw_payload_queue, message
            break
          end
        end
      end

      # TODO: the right data is published
    end
  end
end