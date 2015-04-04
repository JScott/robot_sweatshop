require_relative 'common'
require_relative '../config'

def empty_job
  "---\nbranch_whitelist:\n- master\n\ncommands:\n- echo 'Hello $WORLD!'\n\nenvironment:\n  WORLD: Earth\n"
end

def create_and_edit_job(job_path)
  create_and_edit job_path, with_default: empty_job
end

def list_jobs
  job_directory = File.expand_path configatron.job_directory
  puts Dir.glob("#{job_directory}/*.yaml").map { |file| File.basename(file, '.yaml') }
end
