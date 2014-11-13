require_relative 'payload'
require_relative 'output'

def verify_scripts(scripts)
  missing_scripts = scripts.reject do |script|
    current_dir = File.expand_path File.dirname(__FILE__)
    File.exists? "#{current_dir}/../#{script}"
  end
  unless missing_scripts.empty?
    throw_error "Stopping. Couldn't find scripts to run:\n#{missing_scripts}"
  end
end

def from_workspace(job, logger=Logger.new(STDOUT))
  path = workspace_path_for job
  logger.info "Working from '#{path}' for '#{job}'"
  FileUtils.mkdir_p path
  Dir.chdir path do
    yield
  end
end

def workspace_path_for(job_name)
  current_dir = File.expand_path File.dirname(__FILE__)
  # TODO: force relative to home path. less confusing that using '..'
  "#{current_dir}/../workspaces/#{job_name}"
end

def run_script(path, logger=Logger.new(STDOUT))
  logger.info "Running '#{path}'..."
  # TODO: path.split(' ') to bypass the shell when we're not using env vars
  IO.popen(path) do |io|
    while line = io.gets
      logger.info line
    end
  end
  logger.info "Script done. (exit status: #{$?.exitstatus})"
end

def run_scripts(job_name, scripts, logger=Logger.new(STDOUT))
  from_workspace(job_name, logger) do
    scripts.each { |command| run_script command, logger }
  end
end
