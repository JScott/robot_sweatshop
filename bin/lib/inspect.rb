def valid_lists?(job)
  errors = false
  %w(branch_whitelist commands).each do |list|
    if job[list].nil? || job[list].empty?
      notify :failure, "#{list} empty or not found"
      errors = true
    end
  end
  errors
end

def valid_environment?(job)
  errors = false
  job['environment'].each do |key, value|
    unless value.is_a? String
      notify :warning, "Non-string value for '#{key}'"
      errors = true
    end
  end
  errors
end

def valid_yaml?(job)
  if job
    true
  else
    notify :failure, "Invalid YAML"
    false
  end
end

def validate(job_file:)
  unless File.file?(job_file)
    notify :failure, 'Job not found. Create it with \'workshop job\''
  else
    job = YAML.load_file job_file
    return unless valid_yaml?(job)
    errors = valid_lists?(job) |
             valid_environment?(job)
    notify :success, 'Valid job configuration' unless errors
  end
end
