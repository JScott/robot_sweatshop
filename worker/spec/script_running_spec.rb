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
      expect_any_instance_of(Logger).to receive(:info).with(/Running/)
      expect_any_instance_of(Logger).to receive(:info).with("1\n")
      expect_any_instance_of(Logger).to receive(:info).with(/exit status/)
      work_on command
    end
  end

  describe 'start_job' do
    before(:context) do
      @test_job = 'test-job'
      @scripts = ['echo 1']
    end

    it 'changes the working directory to a job-specific workspace' do
      hide_stdout
      expect(Dir).to receive(:chdir).with(/workspaces\/#{@test_job}/)
      start_job @test_job, @scripts
    end
    
    it 'outputs the workspace path to stdout' do
      expect_any_instance_of(Logger).to receive(:info).with(/workspaces\/#{@test_job}/)
      expect_any_instance_of(Logger).to receive(:info).at_least(:once)
      start_job @test_job, @scripts
    end

    it 'kicks off work on the given job\'s scripts' do
      hide_stdout
      @scripts.each do |script|
        expect_any_instance_of(Object).to receive(:work_on).with(script, anything)
      end
      start_job @test_job, @scripts
    end
  end
end
