require_relative '../../worker/lib/queuing'
require_relative '../lib/payload'
require_relative '../lib/job'

module DataHelper
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
