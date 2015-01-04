require 'logger'
require 'fileutils'

def from_workspace(job_name)
  path = workspace_path for_job: job_name
  FileUtils.mkpath path
  Dir.chdir(path) { yield if block_given? }
end

def workspace_path(for_job:)
  File.expand_path "#{__dir__}/../workspaces/#{for_job}"
end

def run(command, log: Logger.new(STDOUT))
  log.info "Running '#{command}'..."
  # TODO: path.split(' ') to bypass the shell when we're not using env vars
  IO.popen(command) do |io|
    while line = io.gets do
      log.info line
    end
  end
  log.info "Script done. (exit status: #{$?.exitstatus})"
end
