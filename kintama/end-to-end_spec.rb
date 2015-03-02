require 'kintama'
require 'ezmq'
require 'http'
require_relative 'shared/moneta_backup'
require_relative 'shared/process_spawning'
require_relative 'shared/helpers'

describe 'Robot Sweatshop' do
  include QueueHelper
  include InHelper
  include JobHelper

  setup do
    @client = EZMQ::Client.new port: 5556
    @job_name = 'example'
    @test_file = reset_test_file
    clear_all_queues
  end

  context "POST git data to the HTTP Input" do
    setup do
      url = "http://localhost/bitbucket/payload-for/#{@job_name}"
      HTTP.post url, body: load_payload('bitbucket')
      sleep $for_a_while
    end

    should 'run jobs with the context as environment variables' do
      assert_equal "success\n", File.read(@test_file)
    end
  end
end
