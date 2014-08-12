require_relative 'parse/bitbucket'

def parser_for(tool)
  case tool
  when 'bitbucket'
    BitbucketPayload
  else
    nil
  end
end

def parse_payload(tool, data)
  parse = parser_for tool
  if parse.nil?
    raise "Stopping. No parser for tool:\n#{tool}"
  end
  parse.new data
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

def run_scripts(scripts, payload_object)
  scripts.each do |path|
    puts "Running #{path}..."
    IO.popen(File.expand_path path) do |io|
      while line = io.gets
        puts line
      end
    end
    puts "Script done. (exit status: #{$?.exitstatus})"
  end
end


