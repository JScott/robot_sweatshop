require 'bundler/setup'
require 'kintama'
require 'timeout'
require 'http'
require 'nokogiri'
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

  context '/' do
    setup { Timeout.timeout($a_while) { @response = HTTP.get overseer_url } }
    should('respond') { assert_equal 200, @response.code }
    should('link to process logs') do
      page = Nokogiri::HTML(@response.to_s)
      links = page.css('a').select { |link| link.text.include? 'worker' }
      assert_not_equal 0, links.count
    end
    should('have a form for running jobs') do
      page = Nokogiri::HTML(@response.to_s)
      form = page.css('form.job_runner')
      assert_not_equal 0, form.count
    end
  end
  context '/log' do
    setup { Timeout.timeout($a_while) { @response = HTTP.get overseer_url('log') } }
    should('redirect') { assert_equal 303, @response.code }
  end
  context '/log?for=worker' do
    setup { Timeout.timeout($a_while) { @response = HTTP.get overseer_url('log?for=worker') } }
    should('respond') { assert_equal 200, @response.code }
    should('show logs from file') do
      page = Nokogiri::HTML(@response.to_s)
      log = File.read "#{configatron.logfile_path}/worker.log"
      output = page.css('.raw_log').first
      assert_equal log, output.text, 'Expected raw log output'
    end
  end
end
