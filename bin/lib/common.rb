def notify(type = :success, string)
  color = case type
  when :success
    :green
  when :failure
    :red
  when :warning
    :yellow
  when :info
    :light_blue
  else
    ''
  end
  puts "[#{type.to_s.capitalize.colorize(color)}] #{string}"
end

def get_job_file(for_job:)
  for_job = "#{__dir__}/../../jobs/#{for_job}.yaml"
  if for_job.nil?
    notify :failure, 'Please specify the job to create or edit. See --help for details'
    nil
  else
    File.expand_path for_job
  end
end

def edit(file)
  edit = ENV['EDITOR']
  if edit
    notify :info, "Manually editing file '#{file}'"
    system edit, file
  else
    notify :failure, "No editor specified in $EDITOR environment variable"
    notify :info, "Displaying file contents instead"
    system 'cat', file
  end
end

def create_and_edit(file, with_default: '')
  file = File.expand_path file
  unless File.file?(file)
    File.write file, with_default
    notify :success, "Created new file '#{file}'"
  end
  edit file
end
