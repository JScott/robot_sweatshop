require 'logger'
require 'fileutils'

def from_workspace(job)
  path = workspace_path_for job
  puts "Working from '#{path}' for '#{job}'"
  FileUtils.mkdir_p path
  Dir.chdir path do
    yield
  end
end

def workspace_path_for(job_name)
  current_dir = File.expand_path File.dirname(__FILE__)
  "#{current_dir}/../workspaces/#{job_name}"
end

def work_on(path)
  puts "Running '#{path}'..."
  # TODO: path.split(' ') to bypass the shell when we're not using env vars
  IO.popen(path) do |io|
    while line = io.gets
      puts line
    end
  end
  puts "Script done. (exit status: #{$?.exitstatus})"
end

def start_job(job_name, scripts)
  from_workspace(job_name) do
    scripts.each do |command|
      work_on command
    end
  end
end
