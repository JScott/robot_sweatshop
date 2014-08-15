require_relative "../../helpers/payload.rb"
require 'yaml'

describe 'helper/payload.rb' do
  before(:all) do
    payload_path = "#{File.expand_path File.dirname(__FILE__)}/../data/payload.yaml"
    payload_data = YAML.load_file payload_path
    @tools = [
      {name: 'bitbucket', data: payload_data['bitbucket'], parser: BitbucketPayload}
    ]
    @some_tool = @tools.first
  end

  describe 'parser_for' do
    it 'returns a tool-appropriate class' do
      @tools.each do |tool|
        expect(parser_for tool[:name]).to eq tool[:parser]
      end
    end
    it 'throws an error if the tool is not supported' do
      expect { parser_for '' }.to raise_error
    end
  end
  
  describe 'verify_payload' do
    before(:all) do
      parse = parser_for @some_tool[:name]
      @payload = parse.new @some_tool[:data]
    end
    it 'does nothing if the branch is on the watchlist' do
      branch_watchlist = ['master']
      expect { verify_payload @payload, branch_watchlist }.to_not raise_error
    end
    it 'raises an exception if the branch is not being watched' do
      branch_watchlist = ['develop']
      expect { verify_payload @payload, branch_watchlist }.to raise_error
    end
  end

  describe 'set_environment_variables' do
    before(:all) do
      parse = parser_for @some_tool[:name]
      @payload = parse.new @some_tool[:data]
    end
    it 'sets environment variables to the payload string data' do
      set_environment_variables @payload
      expected_values = {
        'CI_GIT_AUTHOR' => 'Marcus Bertrand <marcus@somedomain.com>',
        'CI_GIT_HASH' => '620ade18607ac42d872b568bb92acaa9a28620e9',
        'CI_GIT_BRANCH' => 'master',
        'CI_GIT_MESSAGE' => "Added some more things to somefile.py\n",
        'CI_GIT_REPO_SLUG' => 'marcus/project-x',
        'CI_GIT_SOURCE_URL' => 'https://bitbucket.org/marcus/project-x/src/620ade18607ac42d872b568bb92acaa9a28620e9/?at=master'
      }
      expected_values.each do |key, value|
        expect(ENV[key]).to eq value
      end
    end
  end
end
