require 'fileutils'
require_relative '../config'

def notify(type = :success, string)
  color = case type
  when :success
    :green
  when :failure
    :red
  when :warning
    :yellow
  when :info
    :light_blue
  else
    ''
  end
  puts "[#{type.to_s.capitalize.colorize(color)}] #{string}"
end

def get_job_file(for_job:)
  job_file = File.expand_path "#{configatron.job_directory}/#{for_job}.yaml"
  unless File.file?(job_file)
    create job_file, with_contents: empty_job
  end
  job_file
end

def edit(file)
  edit = ENV['EDITOR']
  if edit
    notify :info, "Manually editing file '#{file}'"
    system edit, file
  else
    notify :failure, "No editor specified in $EDITOR environment variable"
    notify :info, "Displaying file contents instead"
    system 'cat', file
  end
end

def create(file, with_contents: '')
  file = File.expand_path file
  FileUtils.mkdir_p File.dirname(file)
  File.write file, with_contents
  notify :success, "Created new file '#{file}'"
end
