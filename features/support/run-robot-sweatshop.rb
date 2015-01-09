$scripts = [
  'queue/handler.rb',
  'queue/broadcaster.rb'
]

$scripts.map! { |path| File.expand_path "#{__dir__}/../../#{path}" }
$scripts.map! { |path| Process.spawn path }

at_exit do
  $scripts.each do |pid|
    Process.kill "TERM", pid
  end
end
