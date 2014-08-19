require_relative 'scripts'
require_relative 'output'

def read_config(relative_path)
  dir = Dir.pwd
  YAML.load_file "#{dir}/#{relative_path}"
end

def set_log_file(config)
  unless config['log_file'].nil?
    log_path = config['log_file']
    log = File.new log_path, 'a+'
    STDOUT.reopen log
    STDOUT.sync = true
    STDERR.reopen log
    STDERR.sync = true
  else
    puts_info "No log file specified, using STDOUT"
  end
end

def set_pid_file(config)
  pid_path = config['pid_file'] || '/var/run/mci.pid'
  File.open pid_path, 'w' do |file|
    file.write Process.pid
  end
end

def get_job_data(job_directory)
  jobs = {}
  Dir.glob("#{job_directory}/*.yaml").each do |path|
    job = YAML.load_file path
    verify_scripts job['scripts']
    job_name = File.basename path, '.yaml'
    jobs[job_name] = job
  end
  return jobs
end

def reject_job(name)
  throw_error "No configuration for job:\n#{name}"
end
