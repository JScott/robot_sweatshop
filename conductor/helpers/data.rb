require_relative '../../worker/lib/queuing'
require_relative '../lib/payload'
require_relative '../lib/job'

module DataHelper
  def get_job(name)
    jobs = load_all_job_data
    halt 404, "Unknown job: #{name}" unless jobs.include? name
    jobs[name]
  end

  def parse_payload_from(tool)
    parse = parser_for tool
    halt 404, "Unknown tool: #{tool}" if parse.nil?
    begin
      request.body.rewind
      parse.new request.body.read
    rescue => exception
      halt 400, "Bad payload: #{exception} (#{exception.backtrace.first})"
    end
  end

  def enqueue(job, payload)
    environment_vars = payload.git_commit_data
    RunScriptsWorker.perform_async job, environment_vars
  end
end
