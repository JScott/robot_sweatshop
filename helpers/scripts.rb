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

def from_workspace(job, logger=nil)
  path = workspace_path_for job
  logger.info "Working from '#{path}' for '#{job}'" if logger
  FileUtils.mkdir_p path
  Dir.chdir path do
    yield
  end
end

def workspace_path_for(job_name)
  "workspaces/#{job_name}"
end

def run_script(path, logger=nil)
  logger.info "Running '#{path}'..." if logger
  IO.popen(path) do |io|
    while line = io.gets
      logger.info line if logger
    end
  end
  logger.info "Script done. (exit status: #{$?.exitstatus})" if logger
end

def run_scripts(job_name, scripts, logger=nil)
  scripts.map! { |path| File.expand_path path }
  from_workspace(job_name, logger) do
    scripts.each { |path| run_script path, logger }
  end
end
