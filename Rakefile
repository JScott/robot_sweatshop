task :test do
  require_relative 'kintama/run_all'
end

#RSpec::Core::RakeTask.new(:test, :process) do |t, args|
#  if args[:process] == 'all'
#    processes = %w(worker conductor)
#    t.pattern = Dir.glob "{#{processes.join ','}}/spec/**/*_spec.rb"
#  else
#    t.pattern = Dir.glob "#{args[:process]}/spec/**/*_spec.rb"
#  end
#end
