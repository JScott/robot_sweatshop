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
    @pids = Processes.start %w(input conveyor payload-parser job-dictionary assembler worker)
    # `#{__dir__}/../bin/sweatshop start`
    sleep $a_while
  end

  teardown do
    Processes.stop @pids
    # `#{__dir__}/../bin/sweatshop stop`
  end

  context "POSTing data to the HTTP Input" do
    setup do
      clear_worker_output
      url = input_url for_job: 'test_job'
      Timeout.timeout($a_while) { @response = HTTP.post url, body: example_raw_payload('JSON') }
    end

    should 'run the appropriate job' do
      assert_equal true, File.file?(worker_output)
    end
  end
end
