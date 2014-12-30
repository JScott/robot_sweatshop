require_relative '../lib/queuing.rb'
require_relative 'helpers/stdout_helper'
require 'rspec/mocks'

RSpec.configure do |c|
  c.include StdoutHelper
end

describe 'worker', 'queuing' do
  before(:context) do
    @job_name = 'test-job'
    @scripts = ['echo 1']
    @test_environment = { test: 2 }
  end
  
  describe 'enqueue_job' do
    it 'queues the job and parameters via Sidekiq' do
      pending('this is just a passthrough and may be slated for deletion')
      expect(RunScriptsWorker).to receive(:perform_async).with(@job_name, @scripts, @test_environment)
      enqueue_job @job_name, @scripts, with_environment_vars: @test_environment
    end
  end
  
  describe RunScriptsWorker, '#perform' do
    before(:context) do
      @worker = RunScriptsWorker.new
    end
    
    before(:each) do
      hide_stdout
    end
    
    it 'sets the given environment variables as string values' do
      expect {
        @worker.perform @job_name, @scripts, with_environment_vars: @test_environment
      }.to change { ENV['test'] }.from(nil).to('2')
    end
      
    it 'starts the queued job' do
      expect(@worker).to receive(:start_job).with(@job_name, @scripts)
      @worker.perform @job_name, @scripts, with_environment_vars: @test_environment
    end
  end
end
