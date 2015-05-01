require_relative '../config'

def default_job
  "---\n# branch_whitelist:\n# - master\n\ncommands:\n- echo \"Hello $WORLD!\"\n\nenvironment:\n  WORLD: Earth\n"
end

def get_job_path(for_job: nil)
  "#{configatron.job_path}/#{for_job}.yaml"
end

def list_jobs
  job_path = File.expand_path configatron.job_path
  puts Dir.glob("#{job_path}/*.yaml").map { |file| File.basename(file, '.yaml') }
end
