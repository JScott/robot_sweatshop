require_relative "#{Dir.pwd}/parse/bitbucket.rb"
require 'yaml'

describe BitbucketPayload do
  before(:all) do
    @payload_data = YAML.load_file "#{Dir.pwd}/spec/data/payload.yaml"
  end

  context 'with a bitbucket payload' do
    before(:all) do
      @payload = BitbucketPayload.new @payload_data['bitbucket']
    end

    it 'parses commit data' do
      expect(@payload.latest_commit['author']).to eq 'marcus'
      expect(@payload.latest_commit['branch']).to eq 'master'      
    end
    
    it 'parses repository data' do
      expect(@payload.repository['owner']).to eq 'marcus'
      expect(@payload.repository['absolute_url']).to eq '/marcus/project-x/'
    end

    it 'parses the source URL' do
      expect(@payload.source_url).to eq 'https://bitbucket.org/marcus/project-x/src/620ade18607ac42d872b568bb92acaa99a28620e9/?at=master'
    end
  end

  context 'with an empty or malformed payload' do
    before(:all) do
      @payload = BitbucketPayload.new @payload_data['bad_bitbucket']
    end

    it 'parses commit data' do
      expect(@payload.latest_commit['author']).to be_empty
      expect(@payload.latest_commit['branch']).to be_empty
    end
    
    it 'parses repository data' do
      expect(@payload.repository['owner']).to be_empty
      expect(@payload.repository['absolute_url']).to be_empty
    end

    it 'parses the source URL' do
      expect(@payload.source_url).to be_empty
    end
  end
end
