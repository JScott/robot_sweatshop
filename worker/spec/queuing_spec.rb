require_relative '../lib/queuing.rb'
require_relative 'helpers/stdout_helper'
require 'rspec/mocks'

RSpec.configure do |c|
  c.include StdoutHelper
end

describe 'worker', 'queuing' do
  describe RunScriptsWorker, '#perform' do
    before(:context) do
      @test_job = {
        'name' => 'test-job',
        'scripts' => ['echo 1', 'echo 2'],
        'environment' => { one: 1 }
      }
      @test_environment = { two: 2 }
      @worker = RunScriptsWorker.new
    end

    before(:each) do
      hide_stdout
    end

    it 'sets the given environment variables as string values' do
      expect {
        @worker.perform @test_job, @test_environment
      }.to change { ENV['one'] }.from(nil).to('1').and change { ENV['two'] }.from(nil).to('2')
    end

    it 'changes the directory to the appropriate workspace' do
      expect(@worker).to receive(:from_workspace).with(named: @test_job['name'])
      @worker.perform @test_job, @test_environment
    end
    
    it 'runs all the scripts from the queued job' do
      expect(@worker).to receive(:run).twice
      @worker.perform @test_job, @test_environment
    end
  end
end
