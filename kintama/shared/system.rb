require 'fileutils'

raise 'Please run with sudo for the sake of process running' unless Process.euid == 0

$for_a_moment = 0.5
$for_a_while = 1.0

def spawn(lib_path)
  puts "Starting #{lib_path}..."
  null_io = File.open File::NULL, 'w'
  @pids << Process.spawn("#{__dir__}/../../lib/#{lib_path}", out: null_io, err: null_io)
end

def spawn_all_processes
  @pids = []
  spawn 'queue/handler.rb'
  spawn 'queue/broadcaster.rb'
  spawn 'payload/parser.rb'
  spawn 'job/assembler.rb'
  #spawn 'in/http.rb' #Sinatra and port 80 causes a ton of problems
  #spawn 'job/worker.rb testingid'
  sleep $for_a_moment
  #sleep 5
end

def kill_all_processes
  sleep $for_a_while
  @pids.each do |pid|
    Process.kill :TERM, pid
    Process.wait pid
  end
end

def backup_moneta
  @moneta_dir = "#{__dir__}/../../lib/queue/lib/moneta"
  @backup_moneta_dir = "#{__dir__}/../../lib/queue/lib/moneta.backup"
  FileUtils.mv @moneta_dir, @backup_moneta_dir, force: true
end

def restore_moneta
  FileUtils.rm_rf @moneta_dir
  FileUtils.mv @backup_moneta_dir, @moneta_dir
end

Kintama.on_start do
  spawn_all_processes
  backup_moneta
end

Kintama.on_finish do
  kill_all_processes
  restore_moneta
end
