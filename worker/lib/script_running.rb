require 'logger'
require 'fileutils'
require 'English'

def from_workspace(named:)
  path = workspace_path named
  FileUtils.mkpath path
  Dir.chdir(path) { yield if block_given? }
end

def workspace_path(job_name)
  File.expand_path "#{__dir__}/../workspaces/#{job_name}"
end

def run(command, log: Logger.new(STDOUT))
  log.info "Running '#{command}'..."
  # TODO: path.split(' ') to bypass the shell when we're not using env vars
  IO.popen(command) do |io|
    while line = io.gets do
      log.info line
    end
  end
  log.info "Script done. (exit status: #{$CHILD_STATUS.exitstatus})"
end
