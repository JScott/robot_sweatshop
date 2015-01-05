require 'logger'
require 'fileutils'
require 'English'

def from_workspace(job, logger = Logger.new(STDOUT))
  path = workspace_path_for job
  logger.info "Working from '#{path}' for '#{job}'"
  FileUtils.mkdir_p path
  Dir.chdir path do
    yield
  end
end

def workspace_path_for(job_name)
  current_dir = File.expand_path File.dirname(__FILE__)
  "#{current_dir}/../workspaces/#{job_name}"
end

def work_on(path, logger = Logger.new(STDOUT))
  logger.info "Running '#{path}'..."
  # TODO: path.split(' ') to bypass the shell when we're not using env vars
  IO.popen(path) do |io|
    while line = io.gets
      logger.info line
    end
  end
  logger.info "Script done. (exit status: #{$CHILD_STATUS.exitstatus})"
end

def start_job(job, with_logger: Logger.new(STDOUT))
  from_workspace(job['name'], with_logger) do
    job['scripts'].each do |command|
      work_on command, with_logger
    end
  end
end
