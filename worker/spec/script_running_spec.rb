def test(hi: 2)
end

require_relative '../lib/scripts'
require 'rspec/mocks'

describe 'work_on' do
  it 'logs debug info' do
    expect_any_instance_of(Logger).to receive(:info).with(/Running/)
    expect_any_instance_of(Logger).to receive(:info).with(/1/)
    expect_any_instance_of(Logger).to receive(:info).with(/exit status/)
    work_on 'echo 1'
  end
  
  it 'can take a custom logger' do
    logger = Logger.new STDERR
    expect(logger).to receive(:info)
    work_on 'echo 1', with_logger: logger
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
