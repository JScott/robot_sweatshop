require_relative "../../helpers/scripts.rb"
require 'yaml'

describe 'helper/scripts.rb' do
  before(:all) do
    payload_path = "#{File.expand_path File.dirname(__FILE__)}/../data/payload.yaml"
    payload_data = YAML.load_file payload_path
    @some_data = payload_data['bitbucket']
  end

  describe 'verify_scripts' do
    it 'does nothing if the scripts are available' do
      scripts = ["spec/data/scripts/hello-world"]
      expect { verify_scripts scripts }.to_not raise_error
    end
    it 'raises an exception if the scripts are not found' do
      scripts = ["these-scripts/do-not-exist"]
      expect { verify_scripts scripts }.to raise_error
    end
  end

  describe 'from_workspace' do
    before(:all) do
      @job = 'test-job'
    end
    it 'performs the given code at the workspace root' do
      from_workspace @job do
        File.write('workspace.txt', 'workspace')
      end
      expect(File.exist? 'workspace.txt').to be_falsey
      expect(File.exist? "#{workspace_path_for @job}/workspace.txt").to be_truthy
    end
  end

  describe 'workspace_path_for' do
    it 'returns the workspace path for a job' do
      expect(workspace_path_for 'test-job').to eq 'workspaces/test-job'
    end
  end

  describe 'run_script' do
    before(:all) do
      @script = "spec/data/scripts/hello-world"
    end
    it 'prints the script output' do
      expect { run_script @script }.to output(/hello world/).to_stdout
    end
    it 'outputs the exit status of the script' do
      expect { run_script @script }.to output(/exit status: 0/).to_stdout
    end
  end

  describe 'run_scripts' do
    before(:all) do
      @job = 'test-job'
      @scripts = [
        "spec/data/scripts/hello-world",
        "spec/data/scripts/hello-file"
      ]
      @payload = @some_data
    end
    it 'calls run_script on all scripts' do
      expect_any_instance_of(Object).to receive(:run_script).twice
      run_scripts @job, @scripts, @payload
    end
    it 'will write files from scripts to the workspace' do
      run_scripts @job, @scripts, @payload
      file_text = File.read "workspaces/#{@job}/hello.txt"
      expect(file_text).to eq 'hello file'
    end
  end
end
