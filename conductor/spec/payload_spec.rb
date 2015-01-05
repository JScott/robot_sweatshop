require_relative '../lib/payload'
require 'yaml'

describe 'conductor', 'payload' do
  before(:context) do
    payload_path = "#{__dir__}/data/bitbucket_payloads.yaml"
    @payload_data = YAML.load_file payload_path
  end

  context 'with a valid bitbucket payload' do
    before(:context) do
      @payload = BitbucketPayload.new @payload_data['bitbucket']
    end

    it 'parses git commit data' do
      expected_author = {
        'name' => 'Marcus Bertrand',
        'email' => 'marcus@somedomain.com',
        'username' => 'marcus'
      }      
      expect(@payload.repo_slug).to eq 'marcus/project-x'
      expect(@payload.source_url).to eq 'https://bitbucket.org/marcus/project-x/commits/620ade18607ac42d872b568bb92acaa9a28620e9/?at=master'
      expect(@payload.clone_url).to eq 'https://bitbucket.org/marcus/project-x/'
      expect(@payload.author).to eq expected_author
      expect(@payload.hash).to eq '620ade18607ac42d872b568bb92acaa9a28620e9'
      expect(@payload.branch).to eq 'master'
      expect(@payload.message).to eq "Added some more things to somefile.py\n"
    end

    it 'can return the git commit data in a hash' do
      expect(@payload.git_commit_data.size).to eq 7
    end
  end

  context 'with a malformed payload' do
    before(:context) do
      @payload = BitbucketPayload.new @payload_data['bad_bitbucket']
    end

    it 'returns nil for commit data' do
      expect(@payload.latest_commit).to be_empty
      expect(@payload.author).to be_empty
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
