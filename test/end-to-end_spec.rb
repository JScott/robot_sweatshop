require 'kintama'
require 'ezmq'
require 'http'
require_relative 'shared/process_spawning'
require_relative 'shared/helpers'

describe 'Robot Sweatshop' do
  include QueueHelper
  include InHelper
  include JobHelper

  setup do
    @client = EZMQ::Client.new port: 5556
    @test_file = reset_test_file
    clear_all_queues
  end

  context "POST git data to the HTTP Input" do
    setup do
      url = input_http_url for_job: 'test_job'
      HTTP.post url, body: example_raw_payload(of_format: 'JSON')
      sleep $for_io_calls
    end

    should 'run jobs with the context as environment variables' do
      assert_equal "success\n", File.read(@test_file)
    end
  end
end
