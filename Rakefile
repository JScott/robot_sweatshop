require 'rspec'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:test, :process) do |t, args|
  if args[:process] == 'all'
    processes = %w(worker conductor)
    t.pattern = Dir.glob "{#{processes.join ','}}/spec/**/*_spec.rb"
  else
    t.pattern = Dir.glob "#{args[:process]}/spec/**/*_spec.rb"
  end
end
