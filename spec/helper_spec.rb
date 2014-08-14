require_relative "#{Dir.pwd}/helper.rb"
require 'yaml'

describe 'server_helper.rb' do
  before(:all) do
    payload_data = YAML.load_file "#{Dir.pwd}/spec/data/payload.yaml"
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

  describe 'verify_scripts' do
    it 'does nothing if the scripts are available' do
      scripts = ["scripts/hello-world"]
      expect { verify_scripts scripts }.to_not raise_error
    end
    it 'raises an exception if the scripts are not found' do
      scripts = ["these-scripts/do-not-exist"]
      expect { verify_scripts scripts }.to raise_error
    end
  end


  describe 'run_scripts' do
    before(:all) do
      @scripts = ["scripts/hello-world"]
      @payload = @some_tool[:data]
    end
    it 'runs the script and prints the output' do
      expect { run_scripts 'test-job', @scripts, @payload }.to output(/hello world/).to_stdout
    end
    it 'outputs the exit status of the script' do
      expect { run_scripts 'test-job', @scripts, @payload }.to output(/exit status: 0/).to_stdout
    end
  end
end
