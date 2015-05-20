require 'bundler/setup'
require 'kintama'
require 'ezmq'
require 'timeout'
require 'robot_sweatshop/config'
require 'robot_sweatshop/connections'
require_relative 'shared/scaffolding'
require_relative 'shared/helpers' # do I need this?
$stdout.sync = true

Kintama.on_start do
  @pids = Processes.start %w(job-dictionary)
end

Kintama.on_finish do
  Processes.stop @pids
end

describe 'the Job Dictionary' do
  include InputHelper
  using ExtendedEZMQ

  setup do
    @client = EZMQ::Client.new port: configatron.job_dictionary_port
    @client.serialize_with_json!
  end

  teardown do
    @client.close
  end

  %w(git_job minimal_job test_job).each do |job_name|
    given "a #{job_name.gsub '_', ' '}" do
      setup do
        @response = Timeout.timeout($a_while) do
          @client.request job_name
        end
      end

      should 'return no error' do
        assert_equal true, @response[:error].empty?
      end

      should 'return a defined job object' do
        assert_kind_of Hash, @response[:data]
        no_environment = job_name =~ /empty|minimal/
        has_whitelist = job_name =~ /git/
        assert_not_nil @response[:data]['branch_whitelist'] if has_whitelist
        assert_not_nil @response[:data]['commands']
        assert_not_nil @response[:data]['environment'] unless no_environment
      end
    end
  end

  %w(empty_job undefined_job weird_job).each do |job_name|
    given "a #{job_name.gsub '_', ' '}" do
      setup do
        @response = Timeout.timeout($a_while) do
          @client.request job_name
        end
      end

      should 'return an error object' do
        assert_kind_of String, @response[:error]
        assert_equal true, @response[:data].empty?
      end
    end
  end
end
