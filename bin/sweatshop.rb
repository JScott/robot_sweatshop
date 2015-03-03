#!/usr/bin/env ruby
require 'yaml'
require 'commander/import'
require 'colorize'

# :name is optional, otherwise uses the basename of this executable
program :name, 'Robot Sweatshop'
program :version, '0.1.0'
program :description, 'A lightweight, unopinionated CI server'
program :help, 'Author', 'Justin Scott <jvscott@gmail.com>'

# default_command :bootstrap

def empty_job
  "---\nbranch_whitelist:\n- master\n\ncommands:\n- echo 'Hello $WORLD!'\n\nenvironment:\n  WORLD: Earth\n"
end

def notify(type = :success, string)
  tag = case type
  when :success
    "[#{'Success'.colorize :green}] "
  when :failure
    "[#{'Failure'.colorize :red}] "
  when :editor
    "[#{'Editor'.colorize :yellow}] "
  else
    ''
  end
  puts "#{tag}#{string}"
end

command :job do |c|
  c.syntax = 'sweatshop job <name>'
  c.description = 'Creates and edits jobs'
  c.action do |args|
    if args.first.nil?
      notify :failure, 'Please specify the job to create or edit'
      puts "Usage: #{c.syntax}"
    else
      job_file = "#{__dir__}/../jobs/#{args.first}.yaml"
      unless File.file?(job_file)
        File.write job_file, empty_job
        notify :success, "Created new job file '#{args.first}.yaml'"
      end
      notify :editor, "Manually editing job file '#{args.first}.yaml'"
      system ENV['EDITOR'], job_file
    end
  end
end

# command :job do |c|
#   c.syntax = 'sweatshop.rb verify <name>'
#   c.description = 'Verify the structure of a job'
#   c.action do |args|
#     job_file = "#{__dir__}/../jobs/#{args.first}.yaml"
#     if args.first.nil? && File.file?(job_file)
#       puts "Usage: #{c.syntax}"
#       puts 'Please specify the existing job to create or edit'
#     else
#       puts "File is good!"
#     end
#   end
# end


# command :bar do |c|
#   c.syntax = 'foobar bar [options]'
#   c.description = 'Display bar with optional prefix and suffix'
#   c.option '--prefix STRING', String, 'Adds a prefix to bar'
#   c.option '--suffix STRING', String, 'Adds a suffix to bar'
#   c.action do |args, options|
#     options.default :prefix => '(', :suffix => ')'
#     say "#{options.prefix}bar#{options.suffix}"
#   end
# end
