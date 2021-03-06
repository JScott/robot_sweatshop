require 'kintama'
require 'ezmq'
require 'timeout'
require 'robot_sweatshop/config'
require 'robot_sweatshop/connections'
require_relative 'shared/scaffolding'
require_relative 'shared/helpers'
$stdout.sync = true

Kintama.on_start do
  Setup.empty_conveyor
  @pids = TestProcess.start %w(assembler conveyor payload-parser job-dictionary)
  Setup.populate_test_jobs
end

Kintama.on_finish do
  TestProcess.stop @pids
end

describe 'the Job Assembler' do
  include InputHelper
  include OutputHelper
  using ExtendedEZMQ

  setup do
    @worker = TestProcess.stub :worker
    # @conveyor = TestProcess::Stub.new 'Server', on_port: configatron.conveyor_port
    @client = EZMQ::Client.new port: configatron.conveyor_port
    @client.serialize_with_json!
  end

  teardown do
    @client.close
  end

  %w(Git JSON MinimalJob EmptyJSON).each do |request|
    given "#{request} requests on the Conveyor" do
      setup do
        @client.request conveyor_enqueue(request)
        Timeout.timeout($a_while) { loop while @worker.output_empty? }
        @worker_data = eval File.read(@worker.output_file) # TODO: oh god why
      end

      should 'push the parsed payload to a Worker' do
        assert_kind_of Hash, @worker_data[:context]
        assert_kind_of Array, @worker_data[:commands]
        assert_kind_of String, @worker_data[:job_name]
      end

      should 'store everything in the context as strings' do
        @worker_data[:context].each do |key, value|
          assert_kind_of String, key
          assert_kind_of String, value
        end
      end

      should 'append scripts_path to the PATH and add it to the context' do
        scripts_path = File.expand_path configatron.scripts_path
        assert_match /#{scripts_path}/, @worker_data[:context]['PATH']
      end

      should 'build the context with a parsed payload' do
        if request == 'Git'
          assert_equal 'develop', @worker_data[:context]['branch']
        elsif request == 'EmptyJSON'
          assert_equal ['PATH'], @worker_data[:context].keys
        else
          assert_equal 'value', @worker_data[:context]['test1']
        end
      end

      should 'grab commands from the job config' do
        assert_match /echo/, @worker_data[:commands].first
      end
    end
  end

  %w(IgnoredBranch UnknownJob EmptyJob NonJSON).each do |request|
    given "#{request} requests on the Conveyor" do
      setup do
        @client.request conveyor_enqueue(request)
        sleep $a_moment
      end

      should 'push nothing to Workers' do
        assert @worker.output_empty?
      end

      should 'tell the Conveyor that the job is finished'
      # testing needs a real conveyor to grab the jobs from
      # so it would require much refactoring and complexity to stub a fake one
      # in order to test that finish is actually called
    end
  end
end
