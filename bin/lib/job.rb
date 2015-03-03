def empty_job
  "---\nbranch_whitelist:\n- master\n\ncommands:\n- echo 'Hello $WORLD!'\n\nenvironment:\n  WORLD: Earth\n"
end

def create_and_edit(job_file:)
  unless File.file?(job_file)
    File.write job_file, empty_job
    notify :success, "Created new job file"
  end
  notify :info, "Manually editing job file"
  system ENV['EDITOR'], job_file
end
