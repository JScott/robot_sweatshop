require 'fileutils'
require 'yaml'

describe 'configurator', 'sweatshop' do
  describe 'job' do
    before(:context) do
      @git_repo = 'git@github.com:ruby/ruby.git'
      @job_path = "#{__dir__}/../../conductor/jobs/ruby.yaml"
    end

    after(:each) do
      FileUtils.rm @job_path
    end

    it 'creates a job configuration from a given git repo' do
      `sweatshop manage #{@git_repo}`
      expect(File.file? @job_path).to be_true
      job = YAML.load_file @job_path
      %w(branches scripts environment).each do |key|
        expect(job).to have_key key
      end
    end
  end
end

describe 'configurator', 'sweatshop-worker' do
end
