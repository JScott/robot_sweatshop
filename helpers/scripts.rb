require_relative 'payload'

def verify_scripts(scripts)
  missing_scripts = scripts.reject { |script| File.exists? File.expand_path(script) }
  unless missing_scripts.empty?
    raise "Stopping. Couldn't find scripts to run:\n#{missing_scripts}"
  end
end

def from_workspace(job)
  puts "Working from workspace for #{job}"
  path = workspace_path_for job
  FileUtils.mkdir_p path
  Dir.chdir path do
    yield
  end
end

def workspace_path_for(job)
  "workspaces/#{job}"
end

def run_script(path)
  puts "Running #{path}..."
  IO.popen(path) do |io|
    while line = io.gets
      puts line
    end
  end
  puts "Script done. (exit status: #{$?.exitstatus})"
end

def run_scripts(job, scripts, payload_object)
  scripts.map! { |path| File.expand_path path }
  from_workspace(job) do
    scripts.each { |path| run_script path }
  end
end


