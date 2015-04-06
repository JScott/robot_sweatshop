require_relative '../config'

def default_job
  "---\nbranch_whitelist:\n- master\n\ncommands:\n- echo 'Hello $WORLD!'\n\nenvironment:\n  WORLD: Earth\n"
end

def get_job_path(for_job: nil)
  "#{configatron.job_directory}/#{for_job}.yaml"
end

def list_jobs
  job_directory = File.expand_path configatron.job_directory
  puts Dir.glob("#{job_directory}/*.yaml").map { |file| File.basename(file, '.yaml') }
end
