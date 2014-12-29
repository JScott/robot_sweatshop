require_relative '../lib/script_running'
require_relative 'helpers/stdout_helper'
require 'rspec/mocks'
require 'fileutils'

RSpec.configure do |c|
  c.include StdoutHelper
end

describe 'worker', 'script_running' do
  describe 'work_on' do
    it 'runs the script' do
      hide_stdout
      temp_file = '/tmp/rspec-test'
      expect {
        work_on "echo 1 >> #{temp_file}"
      }.to change { File.file? temp_file }.from(false).to(true)
      FileUtils.rm temp_file
    end
    
    it 'prints script output to stdout' do
      command = 'echo 1'
      expect { work_on command }.to output(/1/).to_stdout
      expect { work_on command }.to output(/exit status/).to_stdout
    end
  end

  describe 'start_job' do
    before(:context) do
      @test_job = 'test-job'
      @scripts = ['echo 1']
    end

    it 'works out of a job-specific workspace' do
      hide_stdout
      expect(Dir).to receive(:chdir).with(/workspaces\/#{@test_job}/)
      start_job @test_job, @scripts
    end
    
    it 'outputs the workspace path to stdout' do
      expect { start_job @test_job, @scripts }.to output(/Working from/).to_stdout
    end
  end
end
