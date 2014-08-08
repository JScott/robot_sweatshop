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
      @payload.latest_commit['author'] = 'marcus'
      @payload.latest_commit['branch'] = 'master'      
    end
    
    it 'parses repository data' do
      @payload.repository['owner'] = 'marcus'
      @payload.repository['absolute_url'] = '/marcus/project-x/'
    end

    it 'parses the source URL' do
      @payload.source_url = 'https://bitbucket.org/marcus/project-x/src/620ade18607ac42d872b568bb92acaa99a28620e9/?at=master'
    end
  end

  context 'with an empty or malformed payload' do
    before(:all) do
      @payload = BitbucketPayload.new @payload_data['bad_bitbucket']
    end

    it 'parses commit data' do
      @payload.latest_commit['author'] = ''
      @payload.latest_commit['branch'] = ''      
    end
    
    it 'parses repository data' do
      @payload.repository['owner'] = ''
      @payload.repository['absolute_url'] = ''
    end

    it 'parses the source URL' do
      @payload.source_url = ''
    end
  end
end
