require_relative 'parse/bitbucket'

def parser_for(tool)
  case tool
  when 'bitbucket'
    BitbucketPayload
  else
    raise "Stopping. No parser for tool:\n#{tool}"
  end
end

def verify_payload(payload, branch_watchlist)
  unless branch_watchlist.include? payload.branch
    raise "Stopping. '#{payload.branch}' is not on the branch watchlist:\n#{branch_watchlist}"
  end
end

def verify_scripts(scripts)
  missing_scripts = scripts.reject { |script| File.exists? File.expand_path(script) }
  unless missing_scripts.empty?
    raise "Stopping. Couldn't find scripts to run:\n#{missing_scripts}"
  end
end

def run_scripts(job, scripts, payload_object)
  scripts.map! { |path| File.expand_path path }
  puts "Working from workspace for #{job}"
  workspace = "workspaces/#{job}"
  FileUtils.mkdir_p workspace
  Dir.chdir workspace do
    scripts.each do |path|
      puts "Running #{path}..."
      IO.popen(path) do |io|
        while line = io.gets
          puts line
        end
      end
      puts "Script done. (exit status: #{$?.exitstatus})"
    end
  end
end


