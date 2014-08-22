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
end
