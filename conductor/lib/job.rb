def load_all_job_data
  jobs = {}
  Dir.glob("#{__dir__}/../jobs/*.yaml").each do |path|
    name = File.basename path, '.yaml'
    jobs[name] = YAML.load_file path
    jobs[name]['name'] = name
  end
  jobs
end
