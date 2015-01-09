$subprocesses = {}

at_exit do
  $subprocesses.each do |name, pid|
    STDOUT.puts "Shutting down testing #{name} (pid #{pid})"
    Process.kill "TERM", pid
    Process.wait
  end
  exit
end
