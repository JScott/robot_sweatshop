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

def with_job_file(for_job:)
  if for_job.nil?
    notify :failure, 'Please specify the job to create or edit. See --help for details'
  else
    yield "#{__dir__}/../../jobs/#{for_job}.yaml"
  end
end
