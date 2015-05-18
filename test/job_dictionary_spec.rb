require 'bundler/setup'
require 'kintama'
require 'ezmq'
require 'oj'
require 'timeout'
require 'robot_sweatshop/config'
require_relative 'shared/setup'
require_relative 'shared/helpers' # do I need this?
$stdout.sync = true

Kintama.on_start do
  @pid = Setup::process 'job-dictionary'
end

Kintama.on_finish do
  Process.kill 'TERM', @pid
end

describe 'the Job Dictionary' do
  include InputHelper

  setup do
    @client = Setup::client port: configatron.job_dictionary_port
  end

  %w(git_job minimal_job test_job).each do |job_name|
    given "some #{job_name.gsub '_', ' '}" do
      setup do
        @response = Timeout.timeout($a_while) do
          @client.request job_name
        end
      end

      should 'return no error' do
        assert_equal true, @response[:error].empty?
      end

      should 'return a defined job object' do
        assert_kind_of Hash, @response[:payload]
        no_environment = job_name =~ /empty|minimal/
        has_whitelist = job_name =~ /git/
        assert_not_nil @response[:payload]['branch_whitelist'] if has_whitelist
        assert_not_nil @response[:payload]['commands']
        assert_not_nil @response[:payload]['environment'] unless no_environment
      end
    end
  end

  %w(empty_job undefined_job weird_job).each do |job_name|
    given "some #{job_name.gsub '_', ' '}" do
      setup do
        @response = Timeout.timeout($a_while) do
          @client.request 'not_a_job'
        end
      end

      should 'return an error object' do
        assert_kind_of String, @response[:error]
        assert_equal true, @response[:payload].empty?
      end
    end
  end
end
