require 'bundler/setup'
require 'kintama'
require 'timeout'
require 'http'
require_relative 'shared/scaffolding'
require_relative 'shared/helpers'
$stdout.sync = true

Kintama.on_start do
  @pids = TestProcess.start %w(overseer)
  sleep $a_while
end

Kintama.on_finish do
  TestProcess.stop @pids
end

given 'the Overseer' do
  include OverseerHelper

  context 'the root path' do
    setup { Timeout.timeout($a_while) { @response = HTTP.get overseer_url } }
    should('respond') { assert_equal 200, @response.code }
  end
end
