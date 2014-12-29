require_relative '../lib/scripts'
require_relative 'helpers/stdout_helper'
require 'rspec/mocks'

RSpec.configure do |c|
  c.include StdoutHelper
end

describe 'lib/scripts' do
  describe 'work_on' do
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
    
    it 'outputs the workspace to stdout' do
      expect { start_job @test_job, @scripts }.to output(/Working from/).to_stdout
    end
  end
end
