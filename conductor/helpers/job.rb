require_relative '../../worker/lib/queuing'

module JobsHelper
  def load_all_job_data
    jobs = {}
    Dir.glob("#{__dir__}/../jobs/*.yaml").each do |path|
      name = File.basename path, '.yaml'
      jobs[name] = YAML.load_file path
      jobs[name]['name'] = name
    end
    return jobs
  end

  def get_job(name)
    jobs = load_all_job_data
    halt 404, "Unknown job: #{name}" unless jobs.include? name
    return jobs[name]
  end
  
  def parse_payload_from(tool)
    parse = parser_for tool
    halt 404, "Unknown tool: #{tool}" if parse.nil?
    begin
      request.body.rewind
      parse.new request.body.read
    rescue => exception
      halt 400, "Bad payload: #{exception.to_s} (#{exception.backtrace.first})"
    end
  end

  def enqueue(job, payload)
    environment_data = payload.git_commit_data
    environment_data.merge! job['environment'] unless job['environment'].nil?
    RunScriptsWorker.perform_async job, environment_data
  end
end
