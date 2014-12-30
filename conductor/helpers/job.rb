require_relative '../../worker/lib/queuing'

module JobsHelper
  def load_all_job_data
    jobs = {}
    Dir.glob("#{__dir__}/../jobs/*.yaml").each do |path|
      name = File.basename path, '.yaml'
      jobs[name] = YAML.load_file path
    end
    return jobs
  end

  def get_job(name)
    jobs = load_all_job_data
    halt 404, "Unknown job: #{name}" unless jobs.include? name
    return jobs[name].merge name: name
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

  def enqueue(payload, job)
    env_data = payload.git_commit_data
    env_data.merge! job['environment'] unless job['environment'].nil?
    RunScriptWorker.perform_async job, with_environment_vars: env_data
  end
end
