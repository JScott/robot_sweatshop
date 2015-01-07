require 'moneta'

Before do
  unless $queue_storage_opened
    moneta_dir = File.expand_path "#{__dir__}/moneta"
    $queues = Moneta.new :File, dir: moneta_dir
    $queue_storage_opened = true
  end
end
