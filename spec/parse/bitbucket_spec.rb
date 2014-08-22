require_relative "#{Dir.pwd}/parse/bitbucket.rb"
require 'yaml'

describe BitbucketPayload do
  before(:all) do
    payload_path = "#{File.expand_path File.dirname(__FILE__)}/../data/payload.yaml"
    @payload_data = YAML.load_file payload_path
  end

  context 'with a bitbucket payload' do
    before(:all) do
      @payload = BitbucketPayload.new @payload_data['bitbucket']
    end

    it 'parses commit data' do
      expect(@payload.latest_commit).to_not be_empty
      expect(@payload.author).to eq 'Marcus Bertrand <marcus@somedomain.com>'
      expect(@payload.hash).to eq '620ade18607ac42d872b568bb92acaa9a28620e9'
      expect(@payload.branch).to eq 'master'
      expect(@payload.message).to eq "Added some more things to somefile.py\n"
    end
    
    it 'parses repository data' do
      expect(@payload.repository).to_not be_empty
      expect(@payload.repo_slug).to eq 'marcus/project-x'
    end

    it 'parses the source URL' do
      expect(@payload.source_url).to eq 'https://bitbucket.org/marcus/project-x/src/620ade18607ac42d872b568bb92acaa9a28620e9/?at=master'
    end

    it 'casts to hash for environment variables purposes' do
      hash = @payload.to_hash
      expected_hash = {
        'CI_GIT_AUTHOR' => 'Marcus Bertrand <marcus@somedomain.com>',
        'CI_GIT_HASH' => '620ade18607ac42d872b568bb92acaa9a28620e9',
        'CI_GIT_BRANCH' => 'master',
        'CI_GIT_MESSAGE' => "Added some more things to somefile.py\n",
        'CI_GIT_REPO_SLUG' => 'marcus/project-x',
        'CI_GIT_SOURCE_URL' => 'https://bitbucket.org/marcus/project-x/src/620ade18607ac42d872b568bb92acaa9a28620e9/?at=master'
      }
      expect(hash).to eq expected_hash
    end
  end

  context 'with a malformed payload' do
    before(:all) do
      @payload = BitbucketPayload.new @payload_data['bad_bitbucket']
    end

    it 'returns nil for commit data' do
      expect(@payload.latest_commit).to be_empty
      expect(@payload.author).to be_nil
      expect(@payload.hash).to be_nil
      expect(@payload.branch).to be_nil
      expect(@payload.message).to be_nil
    end
    
    it 'returns nil for repository data' do
      expect(@payload.repository).to be_empty
      expect(@payload.repo_slug).to be_nil
    end

    it 'returns an empty source URL' do
      expect(@payload.source_url).to be_empty
    end
  end
end
