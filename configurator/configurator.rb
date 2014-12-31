#!/usr/bin/env ruby

require 'rubygems'
require 'commander/import'

require 'yaml'
require 'colorize'

program :version, '0.0.1'
program :description, 'A configuration tool for the Robot Sweatshop'
 
command :job do |c|
  c.syntax = 'sweatshop job <job-name|git-url> [options]'
  c.summary = ''
  c.description = ''
  c.example 'description', 'command example'
  #c.option '--some-switch', 'Some switch that does something'
  c.action do |args, options|
    job_name = args.first
    job_name = File.basename job_name, '.git' if job_name.match /.git$/
    job_path = File.expand_path "#{__dir__}/../conductor/jobs"
    job_file = "#{job_path}/#{job_name}.yaml"

    if (File.file? job_file)
      tty = `tty`.strip
      `$EDITOR #{job_file} < #{tty} > #{tty}`
    else
      template = {
        'branches' => ['master', 'develop'],
        'scripts' => ['echo $MESSAGE'],
        'environment' => { 'MESSAGE' => 'Hello world!' }
      }
      File.open(job_file, 'w') do |file|
        yaml = template.to_yaml
        yaml.gsub! /(scripts|environment)/, "\n\\1"
        file.write yaml
      end
      print "Created       ".green, "#{job_file}\n"
      print "Git hook URL  ".light_blue, "http://<sinatra_url>/:tool/payload-for/#{job_name}\n"
    end
  end
end

