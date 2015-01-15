require_relative '../lib/payload'

describe 'conductor', 'parser_for' do
  it 'returns a payload parser for bitbucket' do
    expect(parser_for 'bitbucket').to be BitbucketPayload
  end

  it 'returns nil for an unrecognized tool' do
    expect(parser_for 'whatever').to be_nil
  end
end
