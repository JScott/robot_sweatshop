require_relative '../lib/script_running'
require_relative 'helpers/stdout_helper'
require 'rspec/mocks'
require 'fileutils'

RSpec.configure do |c|
  c.include StdoutHelper
end

describe 'worker', 'script_running' do
  describe 'run' do
    it 'runs a command' do
      hide_stdout
      temp_file = '/tmp/rspec-test'
      expect {
        run "echo 1 >> #{temp_file}"
      }.to change { File.file? temp_file }.from(false).to(true)
      FileUtils.rm temp_file
    end

    it 'prints script output to stdout' do
      command = 'echo 1'
      expect_any_instance_of(Logger).to receive(:info).with(/Running/)
      expect_any_instance_of(Logger).to receive(:info).with("1\n")
      expect_any_instance_of(Logger).to receive(:info).with(/exit status/)
      run command
    end
  end

  describe 'from_workspace' do
    it 'changes the working directory' do
      job_name = 'test'
      expect(Dir).to receive(:chdir).with(/workspaces\/#{job_name}/)
      from_workspace named: job_name do
        expect(Dir.pwd).to be workspace_path(job_name)
      end
    end
  end
end
