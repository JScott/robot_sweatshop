require 'fileutils'
require 'robot_sweatshop/payload'
require 'robot_sweatshop/config'

module OutputHelper
  def worker_output
    "#{configatron.workspace_path}/test_job-testingid/test.txt"
  end

  def clear_worker_output
    FileUtils.rm_rf worker_output
  end
end
