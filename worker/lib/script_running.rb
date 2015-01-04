require 'logger'
require 'fileutils'

def from_workspace(job_name)
  path = workspace_path_for job_name
  FileUtils.mkpath path
  Dir.chdir(path) { yield if block_given? }
end

def workspace_path_for(job_name)
  current_dir = File.expand_path File.dirname(__FILE__)
  "#{current_dir}/../workspaces/#{job_name}"
end

def run(command, log: Logger.new(STDOUT))
  log.info "Running '#{command}'..."
  # TODO: path.split(' ') to bypass the shell when we're not using env vars
  IO.popen(command) do |io|
    while line = io.gets
      log.info line
    end
  end
  log.info "Script done. (exit status: #{$?.exitstatus})"
end
