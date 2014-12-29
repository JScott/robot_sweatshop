require_relative '../lib/scripts'
require 'rspec/mocks'

describe 'lib/scripts' do
  describe 'work_on' do
    it 'prints scrpit output to stdout' do
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
      expect(Dir).to receive(:chdir).with(/workspaces\/#{@test_job}/)
      start_job @test_job, @scripts
    end
  end
end
