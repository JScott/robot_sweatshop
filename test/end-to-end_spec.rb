require 'bundler/setup'
require 'kintama'
require 'ezmq'
require 'http'
require_relative 'shared/scaffolding'
require_relative 'shared/helpers'

describe 'Robot Sweatshop' do
  include InputHelper
  include OutputHelper

  setup do
    Setup.empty_conveyor
    @pids = TestProcess.start %w(api conveyor payload-parser job-dictionary assembler worker)
    Setup.populate_test_jobs
    sleep $a_while
  end

  teardown do
    TestProcess.stop @pids
  end

  context "POSTing data to the API" do
    setup do
      clear_worker_output
      url = job_running_url for_job: 'test_job'
      Timeout.timeout($a_while) { @response = HTTP.post url, body: example_raw_payload('JSON') }
    end

    should 'run the appropriate job' do
      Timeout.timeout($a_while) { loop until File.exist? worker_output }
      assert_equal true, File.file?(worker_output)
    end
  end
end
