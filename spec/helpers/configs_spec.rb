require_relative "../../helpers/configs.rb"

describe "helper/configs.rb" do
  before(:all) do
    @config_path = 'spec/data/config.yaml'
  end
  describe 'read_config' do
    it 'returns the config file from the server root path' do
      config = read_config @config_path
      expect(config).to_not be_nil
      expect(config).to be_instance_of(Hash)
    end
  end
  describe 'set_log_file' do
    before(:all) do
      @config = read_config @config_path
    end
    it 'redirects STDOUT and STDERR to a given file' do
      skip "Redirecting STDOUT causes issues with RSpec"
      set_log_file @config
      string = 'hi'
      puts string
      expect(File.read @config['log_file']).to equal string
    end
  end
  describe 'set_pid_file' do
    before(:all) do
      @config = read_config @config_path
    end
    it 'creates a PID file with the PID of this script' do
      set_pid_file @config
      expect(File.read @config['pid_file']).to eq Process.pid.to_s
    end
  end
  describe 'get_job_data' do
    it 'retrieves job data from a directory' do
      jobs = get_job_data './spec/data/jobs/valid'
      expect(jobs.count).to eq 2
      expect(jobs['two']).to_not be_nil
    end
    it 'verifies the integrity of that data' do
      expect {
        get_job_data './spec/data/jobs/invalid'
      }.to throw_symbol(:error)
    end
  end
  describe 'reject_job' do
    it 'throws an error' do
      expect { reject_job 'test' }.to throw_symbol(:error)
    end
  end
end
